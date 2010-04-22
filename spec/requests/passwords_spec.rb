require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
 
describe "passwords" do
  # It seems I can't spec requests unless I add an application.html.erb file.
  # So the following two lines and the associated code in the before and after
  # blocks create and delete that file.
  LAYOUT_FILE = Merb.root / "app/views/layout/application.html.erb"
  @layout_file_exits = false

  before(:all) do
    Merb::Router.reset!
    Merb::Router.prepare { slice(:merb_auth_slice_password_reset) }
    User.auto_migrate!
    
    @u = User.create(:email => "homer@simpsons.com", :login => "homer")
    @u.generate_password_reset_code
    @code = @u.password_reset_code
    
    if File.exists?(LAYOUT_FILE)
      @layout_file_exits = true
    else
      File.open(LAYOUT_FILE, 'w') {|f| f.write("<%= catch_content :for_layout %>") }
    end
  end

  after(:all) do
    Merb::Router.reset!
    
    File.delete(LAYOUT_FILE) unless @layout_file_exits
  end

  describe "reset" do
    
    before(:each) do
      @response = request("/reset_password/#{@code}")
    end
        
    it "should respond successfully" do
      @response.should be_successful
    end
    
    it "should return a form to the user" do
      @response.should have_xpath("//form")
    end
    
    it "should send the completed form params to /reset_check" do
      @response.should have_xpath("//form[@action='/reset_check/#{@code}']")
    end
    
    it "should have password and password_confirmation attributes wrapped in a user object" do
      @response.should have_xpath("//input[@name='user[password]']")
      @response.should have_xpath("//input[@name='user[password_confirmation]']")      
    end
    
    it "should raise a 404 if the code doesn't match a user" do
      request("/reset_password/nonsense").status.should == 404
    end
        
  end

  describe "reset_check" do

    before(:each) do
      @response = request("/reset_check/#{@code}", :method => "POST",
        :params => { :user => { :password => :blah, :password_confirmation => :blah } } )
    end

    it "should raise a 404 if the code doesn't match a user" do
      request("/reset_check/nonsense").status.should == 404
    end

    it "should redirect to root if the user is saved" do
      @response.should redirect_to("/", :message => {:notice => "Your password has been changed"})
    end

    it "should render the reset form if the user can't be saved" do
      class User; def update(val); return false; end; end
      response = request("/reset_check/#{@code}", :method => "POST",
        :params => { :user => { :password => :blah, :password_confirmation => :blah } } )
      response.should have_xpath("//form[@action='/reset_check/#{@code}']")
    end
    
  end

end
