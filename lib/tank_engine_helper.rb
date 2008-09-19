module TankEngineHelper
  
  ## HTML Headers
  
  def viewport_tag(options = {})
    content = ""
    content += "width = device-width, user-scalable=no" if options[:device_width]
    tag(:meta, :name => "viewport", :content => content)
  end
  
  def include_tank_engine_files
    stylesheet_link_tag('tank_engine') + javascript_include_tag('tank_engine')
  end
  
  ### Navigation Bar
  
  def button_from_hash(hash)
    return "" if hash.blank?
    is_back = (hash.delete(:back) == true)
    if is_back
      hash[:html_options] ||= {}
      hash[:html_options][:id] = "backButton"
      hash[:html_options][:class] = "te_slide_right"
    end
    button_link_to(hash[:caption], hash[:url], hash[:html_options])
  end
  
  def te_navigation_bar(left_button_hash, caption, right_button_hash = {})
    left_button = button_from_hash(left_button_hash)
    header = content_tag(:h1, caption, :id => "header_text")
    right_button = button_from_hash(right_button_hash)
    content = [left_button, header, right_button].join("\n")
    content_tag(:div, content, :class => "toolbar")
  end
  
  ## Link helpers
  
  def button_link_to(name, options, html_options = {})
    html_options[:class] ||= " "
    html_options[:class] += " button"
    link_to(name, options, html_options)
  end
  
  def link_to_replace(name, options, html_options = {})
    html_options[:target] = "_replace"
    link_to(name, options, html_options)
  end
  
  def link_to_external(name, options, html_options = {})
    html_options[:target] = "_self"
    link_to(name, options, html_options)
  end
  
  def link_from_list(name, options, slide = nil, html_options = {})
    if slide
      if html_options[:class]
        html_options[:class] += " te_slide_left"
      else
        html_options[:class] = "te_slide_left"
      end
    end
    link_to(name, options, html_options)
  end
  
  def link_to_target(target, name, options, html_options = {})
    if target == :replace 
      link_to_replace(name, options, html_options)
    elsif target == :self or target == :external
      link_to_external(name, options, html_options)
    else
      link_to(name, options, html_options)
    end
  end
  
#  def servicelink_tel(telno)
#      content_tag("a",telno,:class=>"ciuServiceLink",:target => "_self",:href => "tel:#{telno}" ,:onclick => "return(navigator.userAgent.indexOf('iPhone') != -1)")
#  end
#  def servicelink_email(email)
#      content_tag("a",email,:class=>"ciuServiceLink",:target => "_self",:href => "mailto:#{email}" ,:onclick => "return(navigator.userAgent.indexOf('iPhone') != -1)")
#  end
#  def servicebutton_map(gadr,caption)
#        content_tag("a",caption,:class=>"ciuServiceButton",:target => "_self",:href => "http://maps.google.com/maps?q=#{gadr}" ,:onclick => "return(navigator.userAgent.indexOf('iPhone') != -1)")
#  end


  ## Lists
  
  def list_element(item, target = nil, slide = true)
    link = link_from_list(item.caption, item.url, slide)
    content_tag(:li, link)
  end
  
  def append_options(list_content, options = {})
    list_content = options[:top] + list_content if options[:top]
    list_content += list_element(options[:more], :replace) if options[:more]
    list_content += options[:bottom] if options[:bottom]
    list_content
  end
  
  def te_list(items, options = {})
    slide = !options[:no_slide]
    list_content = items.map {|i| list_element(i, nil, slide)}.join("\n")
    list_content = append_options(list_content, options)
    if options[:as_replace] 
      list_content
    else
      content_tag(:ul, list_content, :selected => "true")
    end
  end
  
  def te_grouped_list(items, options = {}, &group_by_block)
    groups = items.group_by(&group_by_block).sort
    group_elements = groups.map do |group, members|
      group = content_tag(:li, group, :class => "group")
      member_elements = [group] + members.map { |m| list_element(m) }
    end
    content_tag(:ul, group_elements.flatten.join("\n"), :selected => "true")
  end
  
  ## panels and fields
  
  def fieldset(&block)
    concat(content_tag(:fieldset, capture(&block)), block.binding)
  end
  
  def row(label_text="", &block)
    label = if label_text.blank? then "" else content_tag(:label, label_text) end
    block = if block_given? then capture(&block) else "" end
    div = content_tag(:div, label + block, :class => "row")
    if block_given?
      concat(div, block.binding)
    else
      div
    end
  end
  
  def row_label(&block)
    label = content_tag(:label, capture(&block))
    div = content_tag(:div, label, :class => "row")
    concat(div, block.binding)
  end
  
  def panel(&block)
    div = content_tag(:div, capture(&block), :class => "panel")
    concat(div, block.binding)
  end
  
  def dialog(&block)
    div = content_tag(:div, capture(&block), :class => "dialog")
    concat(div, block.binding)
  end
  
  ## Orientation Change
  
  def observe_orientation_change(url_options = {})
    remote = remote_function :url => url_options, 	
  						:with => "'position=' + String(window.orientation)"
    func = "function() { #{remote}; };"
    javascript_tag("function updateOrientation() { #{remote}; }")
  end
  
  def register_orientation_change
    javascript_tag('$(function() { $("body").bind("orientationchange", updateOrientation) });')
  end
  
end

ActionView::Base.send(:include, TankEngineHelper)
