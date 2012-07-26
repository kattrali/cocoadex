module Cocoadex
  module Templates
    MULTIPLE_CHOICES =<<-EOT
<%= Bri::Templates::Helpers.hrule("Multiple choices:") %>

<%= Bri::Renderer.wrap_list( objects.sort ) %>

    EOT

    REF_DESCRIPTION =<<-EOT

<%= hrule( name ) %>

<% unless specs.empty? %>
<%   max = specs.keys.map {|s| s.length}.max %>
<%   specs.each do |name,value| %>
<%=     wrap(inline_h3(name,value,max)) %>
<%   end %>
<% end %>
<% unless overview.empty? %>
<%=  hrule %>

<%=  section_header( "Overview:" ) %>
<%=  wrap(overview) %>
<% end %>

<%= hrule %>

<% unless data_types.empty? %>
<%=  section_header( "Data Types:" ) %>
<%=  Bri::Renderer.wrap_list( data_types.sort ) %>
<% end %>
    EOT

    CLASS_DESCRIPTION =<<-EOT

<%= hrule( type + ": " + name ) %>
<%= print_origin( origin ) %>

<% if description.empty? %>
  (no description...)
<% else %>
<%= '\n' + description %>
<% end %>
<% unless overview.empty? %>
<%= hrule %>

<%= section_header( "Overview:" ) %>
<%= Bri::Renderer.wrap_row(overview.join('\n\n'), Cocoadex.width) %>
<% end %>

<%= hrule %>

<% unless class_methods.empty? %>
<%= section_header( "Class methods:" ) %>
<%= Bri::Renderer.wrap_list( class_methods.sort ) %>


<% end %>
<% unless instance_methods.empty? %>
<%= section_header( "Instance methods:" ) %>
<%= Bri::Renderer.wrap_list( instance_methods.sort ) %>


<% end %>
<% unless properties.empty? %>
<%= section_header( "Properties:" ) %>
<%= Bri::Renderer.wrap_list( properties.sort ) %>


<% end %>
    EOT

    METHOD_DESCRIPTION =<<-EOT

<%= hrule( name ) %>
<%= print_origin( origin ) %>


<%= Cocoadex.trailing_indent(Bri::Renderer.wrap_row(declaration, Cocoadex.width), 2, 6) %>

<% if return_value %>

<%= Bri::Renderer.wrap_row('Returns: ' + return_value) %>
<% end %>

<%= hrule %>
<% if abstract.empty? %>
  (no description...)
<% else %>
<%= Bri::Renderer.wrap_row(abstract, Cocoadex.width) %>
<% end %>

<% unless parameters.empty? %>
<%= section_header( "Parameters:" ) %>
<% parameters.each do |param| %>

<%= h3(Cocoadex.indent(param.name, 2)).strip %>
<% Bri::Renderer.wrap_row(param.description, Cocoadex.width).split('\n').each do |line| %>
<%= Cocoadex.indent(line, 4) %>
<% end %>
<% end %>


<% end %>
<%= availability %>

    EOT

    PROPERTY_DESCRIPTION =<<-EOT

<%= hrule( name ) %>
<%= print_origin( origin ) %>


<%= Bri::Renderer.wrap_row(declaration, Cocoadex.width) %>
<%= hrule %>
<% if abstract.empty? %>
  (no description...)
<% else %>
<%= Bri::Renderer.wrap_row(abstract, Cocoadex.width) %>
<% end %>

<%= availability %>

    EOT

    DATATYPE_DESCRIPTION =<<-EOT

<%= hrule( name ) %>
<%= print_origin( origin ) %>


<% if declaration %>
<%=  wrap(declaration) %>
<% end %>
<%= hrule %>
<% if abstract.empty? %>
  (no description...)
<% else %>
<%=  wrap(abstract) %>
<% end %>

<% if considerations %>
<%=  wrap(considerations) %>
<% end %>

<% unless fields.empty? %>
<%=  section_header( "Fields:" ) %>
<%   fields.each do |param| %>

<%=    h3(Cocoadex.indent(param.name, 2)).strip %>
<%     wrap(param.description).split('\n').each do |line| %>
<%=      Cocoadex.indent(line, 4) %>
<%     end %>

<%   end %>

<% end %>

<% unless constants.empty? %>
<%=  section_header( "Constants:" ) %>
<%   constants.each do |param| %>

<%=    h3(Cocoadex.indent(param.name, 2)).strip %>
<%     wrap(param.description).split('\n').each do |line| %>
<%=      Cocoadex.indent(line, 4) %>
<%     end %>

<%   end %>

<% end %>

<%= availability %>


Declared in <%= declared_in %>

    EOT
  end
end

module Bri
  module Templates
    module Helpers
      def wrap text
        Bri::Renderer.wrap_row(text, Cocoadex.width)
      end

      def h3 text
        Term::ANSIColor::blue + text + Term::ANSIColor::reset + "\n"
      end

      def inline_h3 title, value, alignment
        length = alignment - title.length
        buffer = length > 0 ? " "*length : ""
        Term::ANSIColor::bold + title + ": " + Term::ANSIColor::reset + "#{buffer}#{value}\n"
      end
      module_function :h3
    end
  end
end
