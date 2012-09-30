module AccountSpecHelper
  def load_credentials(endpoint)
    case endpoint.downcase
      when 'dev'
        {
            :default_endpoint => "http://dev.shipserv.com",
            :default_ssmtml_endpoint => "http://dev.shipserv.com/SSMTML",
            :default_pages_endpoint => "http://dev.shipserv.com/pages",
            :pages_non_shipmate_user => {:email => "mia.austria@gmail.com", :username => "mia.austria@gmail.com", :password => "123456"},
            :pages_shipmate_user => {:email => "jgo@shipserv.com", :username => "jgo@shipserv.com", :password => "123456"},
            :pages_stand_alone_shipmate => {:email => "manilatest05@yahoo.com", :username => "manilatest05@yahoo.com", :password => "123456"},
            :default_buyer => {tnid: 10141, username: 'b_king', password: 'shipserv'},
            :default_supplier => {tnid: 70455, username: 's_king', password: 'shipserv'},
            :inactive_buyer => {tnid: 10615, username: 'b_autotest2', password: 'shipserv'},
            :inactive_supplier => {tnid: 79687, username: 's_autotest', password: 'shipserv'}
        }
      when 'uat'
        {
            :default_endpoint => "http://test.shipserv.com",
            :default_ssmtml_endpoint => "http://test.shipserv.com/SSMTML",
            :pages_admin => {:email => "mia.austria@gmail.com", :username => "mia.austria@gmail.com", :password => "123456"},
            :pages_non_shipmate_user => {:email => "mia.austria@gmail.com", :username => "mia.austria@gmail.com", :password => "123456"},
            :pages_shipmate_user => {:email => "jgo@shipserv.com", :username => "jgo@shipserv.com", :password => "123456"},
            :pages_stand_alone_shipmate => {:email => "manilatest05@yahoo.com", :username => "manilatest05@yahoo.com", :password => "123456"},
            :default_buyer => {tnid: 10141, username: 'b_king', password: 'shipserv'},
            :default_supplier => {tnid: 70455, username: 's_king', password: 'shipserv'}
        }
      when 'uat2'
        {
        }
      when 'live'
        {
        }
    end
  end

  def pending_if_live(message="not expect to pass against old ssws")
    pending message unless ['dev', 'uat'].include?(@endpoint) || ENV['FORCE_PENDING']
  end
end