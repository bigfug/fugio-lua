
fugio = require "fugio"

PinArray = fugio.output( "Array" )

Array = PinArray:get()

Array:setType( "vec3" )
Array:resize( 4 )

Array[ 1 ] = { -1, -1, 0 }
Array[ 2 ] = {  1, -1, 0 }
Array[ 3 ] = { -1,  1, 0 }
Array[ 4 ] = {  1,  1, 0 }

PinArray:update()
