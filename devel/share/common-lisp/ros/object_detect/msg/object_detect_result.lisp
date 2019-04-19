; Auto-generated. Do not edit!


(cl:in-package object_detect-msg)


;//! \htmlinclude object_detect_result.msg.html

(cl:defclass <object_detect_result> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (result
    :reader result
    :initarg :result
    :type std_msgs-msg:Int32MultiArray
    :initform (cl:make-instance 'std_msgs-msg:Int32MultiArray)))
)

(cl:defclass object_detect_result (<object_detect_result>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <object_detect_result>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'object_detect_result)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name object_detect-msg:<object_detect_result> is deprecated: use object_detect-msg:object_detect_result instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <object_detect_result>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader object_detect-msg:header-val is deprecated.  Use object_detect-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <object_detect_result>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader object_detect-msg:result-val is deprecated.  Use object_detect-msg:result instead.")
  (result m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <object_detect_result>) ostream)
  "Serializes a message object of type '<object_detect_result>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'result) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <object_detect_result>) istream)
  "Deserializes a message object of type '<object_detect_result>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'result) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<object_detect_result>)))
  "Returns string type for a message object of type '<object_detect_result>"
  "object_detect/object_detect_result")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'object_detect_result)))
  "Returns string type for a message object of type 'object_detect_result"
  "object_detect/object_detect_result")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<object_detect_result>)))
  "Returns md5sum for a message object of type '<object_detect_result>"
  "de558ca67480455c677f81e5d9870972")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'object_detect_result)))
  "Returns md5sum for a message object of type 'object_detect_result"
  "de558ca67480455c677f81e5d9870972")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<object_detect_result>)))
  "Returns full string definition for message of type '<object_detect_result>"
  (cl:format cl:nil "Header header~%std_msgs/Int32MultiArray result~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: std_msgs/Int32MultiArray~%# Please look at the MultiArrayLayout message definition for~%# documentation on all multiarrays.~%~%MultiArrayLayout  layout        # specification of data layout~%int32[]           data          # array of data~%~%~%================================================================================~%MSG: std_msgs/MultiArrayLayout~%# The multiarray declares a generic multi-dimensional array of a~%# particular data type.  Dimensions are ordered from outer most~%# to inner most.~%~%MultiArrayDimension[] dim # Array of dimension properties~%uint32 data_offset        # padding elements at front of data~%~%# Accessors should ALWAYS be written in terms of dimension stride~%# and specified outer-most dimension first.~%# ~%# multiarray(i,j,k) = data[data_offset + dim_stride[1]*i + dim_stride[2]*j + k]~%#~%# A standard, 3-channel 640x480 image with interleaved color channels~%# would be specified as:~%#~%# dim[0].label  = \"height\"~%# dim[0].size   = 480~%# dim[0].stride = 3*640*480 = 921600  (note dim[0] stride is just size of image)~%# dim[1].label  = \"width\"~%# dim[1].size   = 640~%# dim[1].stride = 3*640 = 1920~%# dim[2].label  = \"channel\"~%# dim[2].size   = 3~%# dim[2].stride = 3~%#~%# multiarray(i,j,k) refers to the ith row, jth column, and kth channel.~%~%================================================================================~%MSG: std_msgs/MultiArrayDimension~%string label   # label of given dimension~%uint32 size    # size of given dimension (in type units)~%uint32 stride  # stride of given dimension~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'object_detect_result)))
  "Returns full string definition for message of type 'object_detect_result"
  (cl:format cl:nil "Header header~%std_msgs/Int32MultiArray result~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: std_msgs/Int32MultiArray~%# Please look at the MultiArrayLayout message definition for~%# documentation on all multiarrays.~%~%MultiArrayLayout  layout        # specification of data layout~%int32[]           data          # array of data~%~%~%================================================================================~%MSG: std_msgs/MultiArrayLayout~%# The multiarray declares a generic multi-dimensional array of a~%# particular data type.  Dimensions are ordered from outer most~%# to inner most.~%~%MultiArrayDimension[] dim # Array of dimension properties~%uint32 data_offset        # padding elements at front of data~%~%# Accessors should ALWAYS be written in terms of dimension stride~%# and specified outer-most dimension first.~%# ~%# multiarray(i,j,k) = data[data_offset + dim_stride[1]*i + dim_stride[2]*j + k]~%#~%# A standard, 3-channel 640x480 image with interleaved color channels~%# would be specified as:~%#~%# dim[0].label  = \"height\"~%# dim[0].size   = 480~%# dim[0].stride = 3*640*480 = 921600  (note dim[0] stride is just size of image)~%# dim[1].label  = \"width\"~%# dim[1].size   = 640~%# dim[1].stride = 3*640 = 1920~%# dim[2].label  = \"channel\"~%# dim[2].size   = 3~%# dim[2].stride = 3~%#~%# multiarray(i,j,k) refers to the ith row, jth column, and kth channel.~%~%================================================================================~%MSG: std_msgs/MultiArrayDimension~%string label   # label of given dimension~%uint32 size    # size of given dimension (in type units)~%uint32 stride  # stride of given dimension~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <object_detect_result>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'result))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <object_detect_result>))
  "Converts a ROS message object to a list"
  (cl:list 'object_detect_result
    (cl:cons ':header (header msg))
    (cl:cons ':result (result msg))
))
