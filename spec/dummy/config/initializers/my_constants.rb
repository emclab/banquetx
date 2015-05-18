#if Rails.env.production?
  SUBURI = ''
  #set session timeout minutes
  SESSION_TIMEOUT_MINUTES = 90
  SESSION_WIPEOUT_HOURS = 12
  H_FROM_GMT = 8
#end

BUTTONS_CLS = {'default' => 'btn btn-primary',
               'action'  => 'btn btn-primary',
               'info'    => 'btn btn-primary',
               'success' => 'btn btn-primary',
               'warning' => 'btn btn-primary',
               'danger'  => 'btn btn-primary',
               'inverse' => 'btn btn-primary',
               'link'    => 'btn btn-primary',
               'right-span#'         => '2', 
               'left-span#'         => '6', 
               'offset#'         => '2',
               'form-span#'         => '4'
              }