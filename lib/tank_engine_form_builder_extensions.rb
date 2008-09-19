module ActionView
  module Helpers
    module FormHelper
      def toggle(object_name, method, options = {})
        obj = instance_variable_get("@#{object_name}")
        value = if obj.send(method) then "ON" else "OFF" end
        hidden = hidden_field_tag("#{object_name}[#{method}]", value, 
            :id => "#{object_name}_#{method}")
        thumb = content_tag(:span, "", :class => "thumb")
        on = content_tag(:span, "ON", :class => "toggleOn")
        off = content_tag(:span, "OFF", :class => "toggleOff")
        toggle = content_tag(:div, thumb + on + off, 
            :toggled => (if obj.send(method) then true else false end),
            :value => value,
            :class => "toggle",
            :id => "#{object_name}_#{method}_toggle")
        row = content_tag(:div, toggle, :class => "row")
        hidden + row
      end
    end
    
    class FormBuilder
        
      def toggle(method, options = {})
        @template.toggle(@object_name, method, objectify_options(options))
      end
      
    end
    
  end
end