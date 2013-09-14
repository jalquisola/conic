module UsersHelper
  def create_social_links(enabled_links)
    socials = ["dailymile", "foursquare", "path", "facebook", "twitter"]
    partial_html = []
    #partial_html << "<ul class='nav nav-pills nav-stacked'>"
    socials.each do |social| 
      link = "/auth/#{social}/callback"
      link = "https://api.dailymile.com/oauth/authorize?response_type=code&client_id=#{DAILYMILE_CONFIG['CLIENT_ID']}&redirect_uri=http://conic.dev/auth/dailymile/callback" if social == "dailymile"

      #partial_html << <<-HTML
      #  <li class=''>
      #    <a href='#{link}'>
      #      <span class='badge pull-right'>
      #        #{enabled_links.include?(social) ? 'ON' : 'OFF'}
      #      </span>
      #      #{social.capitalize}
      #    </a>
      #  </li>
      #HTML
      partial_html << <<-HTML
        <div class="panel panel-info">
          <div class="panel-heading">
            <h3 class="panel-title">
              <a href='#{link}'>
                <span class='badge pull-right'>
                  #{enabled_links.include?(social) ? 'ON' : 'OFF'}
                </span>
                #{social.capitalize}
              </a>
            </h3>
          </div>
          <div class="panel-body">
            <div class="checkbox">
              <label>
                <input type="checkbox"> Allow status update.
              </label>
            </div>
          </div>
        </div>
      HTML
    end
    partial_html << "</ul>"

    partial_html.join('')
  end 
end
