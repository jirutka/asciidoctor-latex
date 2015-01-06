# Test doc: work/click.adoc


# ClickBlock is a first draft for

# Note to self: when done with this, eliminate
# the puts lines with DEVELOPMENT
# or toggle them with $VERBOSE

require 'asciidoctor'
require 'asciidoctor/extensions'
require 'asciidoctor/latex/core_ext/colored_string'
require 'asciidoctor/latex/logger'


module Asciidoctor::LaTeX
  class ClickBlock < Asciidoctor::Extensions::BlockProcessor
    include Logger

    use_dsl
    # ^^^ don't know what this is.  Could you explain?

    named :click
    on_context :open
    # parse_context_as :complex
    # ^^^ The above line gave me an error.  I'm not sure what do to with it.

    # Hash to count the number of times each environment is encountered
    # Global variables again.  Is there a better way?
    $counter = {}

    def process parent, reader, attrs

      log.debug 'begin ClickBlock'
      click_name = attrs["role"]

      # Ensure that role is defined
       if attrs['role'] == nil
         role = 'item'
       else
         role = attrs['role']
       end

       # Use the value of the role to determine
       # whether this is a numbered block
       numbered = false
       if attrs['options'] and attrs['options'].include? 'number'
         numbered = true
       end


       # If the block is numbered, update the counter
       if numbered
         env_name = role     ##############  'click-'+role
         if $counter[env_name] == nil
           $counter[env_name] = 1
         else
           $counter[env_name] += 1
         end
       end


       # Set title
       if role == 'code'
         title = 'Listing'
       else
         title = role.capitalize
       end
       if numbered
         title = title + ' ' + $counter[env_name].to_s
       end
       if attrs['title']
         if numbered
           title = title + '. ' + attrs['title'].capitalize
         else
           title = title + ': ' + attrs['title'].capitalize
         end
       end

       if role != 'equation'
         attrs['title']  = title
       else
         if numbered
           attrs['equation_number'] = $counter[env_name].to_s
         end
       end


      attrs['title'] = title


      if attrs['role'] == 'code'
        role = 'listing'
      else
        role  = 'click'
      end
      attrs['role'] = 'click'


      log.debug "click_name: #{click_name}"
      log.debug 'end Clicklock'

      log.debug "role = #{role}"
      if role == 'listing'
        log.debug 'creating listing block'
        create_block parent, :listing, reader.lines, attrs
      else
        log.debug 'creating click block'
        create_block parent, :click, reader.lines, attrs
      end

    end

  end
end
