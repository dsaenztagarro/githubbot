class JsonApi
  VERSION = '1.0'.freeze

  def response
    {
      errors: [
        {
          title: 'Invalid Pull Request',
          detail: 'The repository has uncommited changes',
          value: data[:counter]
        }
      ]
    }.to_json
  end
end
