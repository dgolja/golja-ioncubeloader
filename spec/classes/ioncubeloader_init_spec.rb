require 'spec_helper'

describe 'ioncubeloader', :type => :class do
      
  context "on a Redhat" do
    let (:facts) do 
      {
        :osfamily      => 'RedHat',
        :hardwaremodel => 'x86_64'
      }
    end

    it { should compile }
    it { should contain_exec('retrieve_ioncubeloader').with_command(
      'wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && tar xzf ioncube_loaders_lin_x86-64.tar.gz && mv ioncube/ /usr/local && touch /usr/local/ioncube/.installed'
      )
    }
    it { should contain_file('/etc/php.d/ioncube.ini').with('ensure'  => 'present') }
    it { should contain_file('/etc/php.d/ioncube.ini').with_content(/zend_extension=\/usr\/local\/ioncube\/ioncube_loader_lin_5.3.so/) }
    

      context "with apache service managed in module" do
      let (:params) do
        {
          'manage_http_service' => true
        }
      end

      it { should contain_class('ioncubeloader::service').that_subscribes_to('File[/etc/php.d/ioncube.ini]') }
      it { should contain_service('httpd').with('name' => 'httpd') }
    end
    
    context "with ensure=>absent" do
      let(:params) { {'ensure' => 'absent'} }
        
      it { should compile }
      it { should_not contain_exec('retrieve_ioncubeloader') }
      it { should contain_file('/etc/php.d/ioncube.ini').with('ensure'  => 'absent') }
      it { should contain_file('/usr/local/ioncube').with(
        'ensure'  => 'absent',
        'backup'  => false,
        'recurse' => true
        )
      }
      it { should contain_file('/tmp/ioncube_loaders_lin_x86-64.tar.gz').with('ensure' => 'absent')}
    end
    
    context "with invalid ensure value" do
      let(:params) { { 'ensure' => 'foo' } }
      
      it 'should fail' do
        expect { subject }.to raise_error(/ensure must be either present or absent/)
      end
    end

  end

  context "on a Debian with ts" do
    let (:facts) do 
      {
        :osfamily      => 'Debian',
        :hardwaremodel => 'x86_64'
      }
    end

    let (:params) { {'ts' => true} }

    it { should compile }
    it { should contain_exec('retrieve_ioncubeloader') }
    it { should contain_file('/etc/php5/conf.d/ioncube.ini').with('ensure'  => 'present') }
    it { should contain_file('/etc/php5/conf.d/ioncube.ini').with_content(/zend_extension=\/usr\/local\/ioncube\/ioncube_loader_lin_5.4_ts.so/) }

    context "with custom params" do
      let (:params) do
        { 
          'ts'             => true,
          'php_version'    => '5.5',
          'php_conf_dir'   => '/etc/php.foo',
          'install_prefix' => '/opt',
          'ini_file'       => 'ioncubicus.ini'
        }
      end
      
      it { should contain_file('/etc/php.foo/ioncubicus.ini') }
      it { should contain_file('/etc/php.foo/ioncubicus.ini').with_content(/zend_extension=\/opt\/ioncube\/ioncube_loader_lin_5.5_ts.so/) }

    end
    
    context "with apache service managed in module" do
      let (:params) do
        {
          'manage_http_service' => true
        }
      end

      it { should contain_class('ioncubeloader::service').that_subscribes_to('File[/etc/php5/conf.d/ioncube.ini]') }
      it { should contain_service('httpd').with('name' => 'apache2') }
    end

    context "with invalid ensure value" do
      let(:params) { { 'ensure' => 'foo' } }
      
      it 'should fail' do
        expect { subject }.to raise_error(/ensure must be either present or absent/)
      end
    end

  end
  
  context "on unsupported OS" do
    let(:facts) { { 'osfamily' => 'foo'} }
    
    it 'should fail' do
      expect { subject }.to raise_error(/Unsupported osfamily foo/)
    end
  end
  
end