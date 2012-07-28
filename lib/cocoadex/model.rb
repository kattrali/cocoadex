require 'cocoadex/models/docset'
require 'cocoadex/models/element'
require 'cocoadex/models/seq_node_element'
require 'cocoadex/models/nested_node_element'
require 'cocoadex/models/entity'
require 'cocoadex/models/constant'
require 'cocoadex/models/parameter'
require 'cocoadex/models/function'
require 'cocoadex/models/callback'
require 'cocoadex/models/result_code'
require 'cocoadex/models/data_type'
require 'cocoadex/models/generic_ref'
require 'cocoadex/models/method'
require 'cocoadex/models/property'
require 'cocoadex/models/class'

module Cocoadex
  # Class Structure -------------
  #
  # DocSet
  # Element
  #   Entity
  #     Class
  #     GenericRef
  #   NestedNodeElement
  #     Method
  #     Property
  #   SequentialNodeElement
  #     Callback
  #     ConstantGroup
  #     DataType
  #     Function
  #   Constant
  #   Parameter
  #   ResultCode
  #
  # Relationship Tree -----------
  #   Class
  #     Method
  #       Parameter
  #     Property
  #
  #   GenericRef
  #     Callback
  #       Parameter
  #     ConstantGroup
  #       Constant
  #     DataType
  #       Parameter
  #     Function
  #       Parameter
  class Model
  end
end