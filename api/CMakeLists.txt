cmake_minimum_required( VERSION 3.14 )

project( fugio-lua-api LANGUAGES CXX )

install( DIRECTORY ${CMAKE_SOURCE_DIR}/fugio-lua/include/fugio DESTINATION . COMPONENT ${PROJECT_NAME} )
install( DIRECTORY ${CMAKE_SOURCE_DIR}/fugio-luaqt/include/fugio DESTINATION . COMPONENT ${PROJECT_NAME} )

set( CPACK_ARCHIVE_FUGIO-LUA-API_FILE_NAME "fugio-lua-api" PARENT_SCOPE )

