module ActionController
  
  module IphoneController
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def acts_as_iphone_controller(options = {})
        include ActionController::IphoneController::InstanceMethods
        @@iphone_options = options
        if options[:test_mode] 
          before_filter :force_iphone_format
        else
          before_filter :set_iphone_format
        end
        helper_method :is_iphone_request?
      end
      
      def iphone_request_format
        return :iphone unless @@iphone_options[:format]
        @@iphone_options[:format].to_sym
      end
      
      def ignore_iphone_user_agent
        @@iphone_options[:ignore_user_agent] || false
      end
      
      def iphone_subdomain
        return :iphone unless @@iphone_options[:subdomain]
        @@iphone_options[:subdomain].to_sym
      end
    end
    
    module InstanceMethods
      
      private
      
      def force_iphone_format
        request.format = :iphone
      end
      
      def set_iphone_format
        if is_iphone_request? || is_iphone_format? || is_iphone_subdomain?
          request.format = if cookies["browser"] == "desktop" 
                           then :html 
                           else :iphone 
                           end
        end
      end
      
      def is_iphone_format?
        request.format.to_sym == self.class.iphone_request_format
      end

      def is_iphone_request?
        return false if self.class.ignore_iphone_user_agent
        request.user_agent =~ /(Mobile\/.+Safari)/
      end
      
      def is_iphone_subdomain?
        return false unless request.subdomains.first
        request.subdomains.first.to_sym == self.class.iphone_subdomain
      end
    end
    
  end
  
end

ActionController::Base.send(:include, ActionController::IphoneController)