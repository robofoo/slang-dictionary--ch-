module PagesHelper
  def encoded_contact_email
    mail_to "ChengshiCidian@gmail.com", "ChengshiCidian@gmail.com", :encode => "javascript"
  end
end
