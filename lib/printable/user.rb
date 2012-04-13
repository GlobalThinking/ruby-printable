require 'htmlentities'
require 'net/https'
require 'uri'

class Printable::User

	attr_accessor :uigroup_id, :company_id

	# =====================================================
	# Set the uigroup_id and company_id for the user
	# =====================================================
	def initialize(uigroup_id, company_id)
		@uigroup_id, @company_id = uigroup_id, company_id
	end

	# =====================================================
	# POST to the signup form and create the user
	# =====================================================
	def create(info)
		# POST to signup form
		res = self._post(
			self.uri_signup,
			self.map_fields(self.uri_signup, info).merge({"__EVENTTARGET" => "ctl00$content$SelfRegFlow$btnSubmitForm"}),
			{"Cookie" => "Printable_CookieCheck=1"}
		)

		# Check for errors
		case res
		when Net::HTTPRedirection
			return true
		else
			raise self.parse_errors(res.body).join("\n")
		end
	end

	# =====================================================
	# Map the form fields located at a particular URI
	# =====================================================
	def map_fields(uri, info)
		# Get the HTML page
		res = self._get(uri, {"Cookie" => "Printable_CookieCheck=1"})

		# Scrape form fields
		fields = Hash.new #{"__EVENTTARGET" => "ctl00$content$SelfRegFlow$btnSubmitForm"}
		res.body.scan(/(<input .*?name=(['"])(.*?)\2.*?>)/im) { |element, x, field|
			# Look for the value (may be nil)
			value = /value=(['"])(.*?)\1/im.match(element)

			# Prefilled fields
			fields[field] = value.nil? ? nil : value[2]

			# Fill field w/ info
			info.each do|n, v|
				next if not Regexp.new(n, true).match(field)

				fields[field] = v
				break
			end
		}

		return fields
	end

	# =====================================================
	# Parse and return any errors that occurred
	# =====================================================
	def parse_errors(text)
		coder = HTMLEntities.new

		errors = Array.new

		# Scan the text for any field errors
		text.scan(/<font.*?>(.*?is +(a +)?required.*?)<.font>/im) do|error, x|
			errors.push(coder.decode(error))
		end

		# Scan the text for any server errors
		text.scan(/<div class=error ><img.*?>(.*?)<.div>/im) do|error, x|
			errors.push(coder.decode(error))
		end

		return errors
	end

	# =====================================================
	# Get the login url
	# =====================================================
	def uri_login
		"https://marcomcentral.app.pti.com/printone/login.aspx?uigroup_id=#{@uigroup_id}&company_id=#{@company_id}"
	end

	# =====================================================
	# Get the signup url
	# =====================================================
	def uri_signup
		"https://marcomcentral.app.pti.com/printone/signup.aspx?uigroup_id=#{@uigroup_id}&company_id=#{@company_id}"
	end

	# =====================================================
	# POST to a url w/ certain parameters
	# =====================================================
	def _get(url, headers=Hash.new)
		uri = URI.parse(url)

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri.request_uri)
		headers.each do|name,value|
			request.add_field name, value
		end

		http.request(request)
	end

	# =====================================================
	# POST to a url w/ certain parameters
	# =====================================================
	def _post(url, params, headers=Hash.new)
		uri = URI.parse(url)

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Post.new(uri.request_uri)
		headers.each do|name,value|
			request.add_field name, value
		end

		request.set_form_data(params)

		http.request(request)
	end
end