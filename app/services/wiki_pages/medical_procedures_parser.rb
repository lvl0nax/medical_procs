require 'net/http'

module WikiPages
  module MedicalProceduresParser
    extend self

    WIKI_URL = 'https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&titles=Medical_procedure&format=json'
    START_STR = '===Propaedeutic===' # beginning of the procedures list
    FINISH_STR = '==See also==' # the last word of the procedure list

    def call
      url = URI(WIKI_URL)
      res = Net::HTTP.get_response(url)
      content = parsed_page_content(res)

      parse_procedures(content)
    end

    private

    def parsed_page_content(response)
      JSON.parse(response.body).dig('query', 'pages').values.last.dig("revisions").last.dig('*')
    end

    def parse_procedures(content)
      return [] if content.blank?

      beginning = content.index(START_STR) + START_STR.size
      finish = content.index(FINISH_STR) - 1
      content = content[beginning..finish]
      content.delete!('*[]')
      content.gsub!(/=+[A-Z][a-z]+=+/, '')

      content.split("\n").each_with_object([]) do |procedure, result|
        next if procedure.blank?

        result << procedure.tap(&:strip!)
      end
    end
  end
end
