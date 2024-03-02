cmake_minimum_required( VERSION 3.14 )

#-------------------------------------------------------------------------------
# PLUGIN DEFINES

set( PLUGIN_NAME "LuaQt" )
set( PLUGIN_DESCRIPTION_SHORT "LuaQt library" )
set( PLUGIN_DESCRIPTION_LONG "LuaQt library" )
set( PLUGIN_FILENAME "fugio-luaqt" )

set( PLUGIN_UUID "c5c8b86c-e6b0-413f-9c27-fb1974d2f464" )
set( PLUGIN_IID "com.bigfug.fugio.luaqt" )

set( PLUGIN_RELEASE_VERSION "1.0.0" )
set( PLUGIN_COMPATIBILITY_VERSION "1.0.0" )
set( PLUGIN_API_COMPATIBILITY "4.0.0" )

set( PLUGIN_RELEASE_DATE "2019-10-25" )
set( PLUGIN_AUTHOR_NAME  "Alex May" )
set( PLUGIN_AUTHOR_CONTACT "https://github.com/bigfug" )

set( PLUGIN_WIKI_LINK "https://github.com/bigfug/fugio-lua/wiki/LuaQt_Plugin" )
set( PLUGIN_WIKI_NODE_LINK "https://github.com/bigfug/fugio-lua/wiki/LuaQt_Node_" )
set( PLUGIN_WIKI_PIN_LINK "https://github.com/bigfug/fugio-lua/wiki/LuaQt_Pin_" )

set( PLUGIN_REQUIREMENTS "\
	{ \"plugin\": \"com.bigfug.fugio.core\", \"version\": \"1.0.0\" },
	{ \"plugin\": \"com.bigfug.fugio.lua\", \"version\": \"1.0.0\" }"
)

#-------------------------------------------------------------------------------

project( ${PLUGIN_FILENAME} VERSION ${PLUGIN_RELEASE_VERSION} LANGUAGES CXX )

set( HEADER_FILES
	include/fugio/luaqt/uuid.h
)

set( SOURCE_FILES
	source/luaqtplugin.cpp
	source/luaqtplugin.h

	source/luabrush.cpp
	source/luabrush.h
	source/luabytearray.cpp
	source/luabytearray.h
	source/luacolor.cpp
	source/luacolor.h
	source/luafont.cpp
	source/luafont.h
	source/luafontmetrics.cpp
	source/luafontmetrics.h
	source/luagradient.cpp
	source/luagradient.h
	source/luaimage.cpp
	source/luaimage.h
	source/luajsonarray.cpp
	source/luajsonarray.h
	source/luajsondocument.cpp
	source/luajsondocument.h
	source/luajsonobject.cpp
	source/luajsonobject.h
	source/lualine.cpp
	source/lualine.h
	source/luamatrix.cpp
	source/luamatrix.h
	source/luamatrix4x4.cpp
	source/luamatrix4x4.h
	source/luapainter.cpp
	source/luapainter.h
	source/luapen.cpp
	source/luapen.h
	source/luapointf.cpp
	source/luapointf.h
	source/luapolygon.cpp
	source/luapolygon.h
	source/luaquaternion.cpp
	source/luaquaternion.h
	source/luarectf.cpp
	source/luarectf.h
	source/luasizef.cpp
	source/luasizef.h
	source/luatransform.cpp
	source/luatransform.h
	source/luavector3.cpp
	source/luavector3.h
)

set( QRC_FILES
)

add_library( ${PROJECT_NAME} MODULE ${SOURCE_FILES} ${HEADER_FILES} ${QRC_FILES} )

set_target_properties( ${PROJECT_NAME} PROPERTIES
  BUNDLE TRUE
)

#------------------------------------------------------------------------------
# Includes

target_include_directories( ${PROJECT_NAME} PRIVATE
	${CMAKE_CURRENT_SOURCE_DIR}/include
	${CMAKE_SOURCE_DIR}/fugio-lua/include
)

#------------------------------------------------------------------------------
# Fugio API

if( FUGIO_API AND EXISTS ${FUGIO_API} )
	target_include_directories( ${PROJECT_NAME} PRIVATE ${FUGIO_API} )

	target_sources( ${PROJECT_NAME} PRIVATE
		${FUGIO_API}/fugio/nodecontrolbase.h
		${FUGIO_API}/fugio/pincontrolbase.h
		)
endif()

#------------------------------------------------------------------------------
# Lua

target_include_directories( ${PROJECT_NAME} PRIVATE ${CMAKE_BINARY_DIR}/lua/include )

target_link_libraries( ${PROJECT_NAME} PRIVATE ${CMAKE_BINARY_DIR}/lua/lib/lua_shared.lib )

target_compile_definitions( ${PROJECT_NAME} PRIVATE LUA_SUPPORTED )

install( FILES
	${CMAKE_BINARY_DIR}/lua/bin/lua_shared.dll
	DESTINATION ${PATH_APP}
	COMPONENT ${PROJECT_NAME}
)

#------------------------------------------------------------------------------
# Eigen

target_include_directories( ${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/libs/eigen )

#------------------------------------------------------------------------------
# Plugin Config

configure_file(
	${CMAKE_SOURCE_DIR}/config.h.in
	${CMAKE_CURRENT_BINARY_DIR}/config.h
	@ONLY
)

target_sources( ${PROJECT_NAME} PRIVATE
	${CMAKE_CURRENT_BINARY_DIR}/config.h
	)

target_include_directories( ${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR} )

#------------------------------------------------------------------------------
# Plugin Manifest

configure_file(
	${CMAKE_SOURCE_DIR}/manifest.json.in
	${CMAKE_CURRENT_BINARY_DIR}/manifest.json
	@ONLY
)

target_sources( ${PROJECT_NAME} PRIVATE
	${CMAKE_CURRENT_BINARY_DIR}/manifest.json
	)

install( FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION . COMPONENT ${PROJECT_NAME} )

#------------------------------------------------------------------------------
# Install

install( TARGETS ${PROJECT_NAME}
	LIBRARY
	DESTINATION plugins
	COMPONENT ${PROJECT_NAME}
)

install( DIRECTORY include DESTINATION . COMPONENT ${PROJECT_NAME} PATTERN ".*" EXCLUDE )
install( DIRECTORY examples	DESTINATION . COMPONENT ${PROJECT_NAME} PATTERN ".*" EXCLUDE )

#------------------------------------------------------------------------------
# Qt5

find_package(Qt6 REQUIRED COMPONENTS Core Core5Compat Widgets LinguistTools QUIET )

if (NOT Qt6_FOUND)
	find_package(Qt5 5.15 REQUIRED COMPONENTS Core Widgets LinguistTools QUIET )
endif()

target_link_libraries( ${PROJECT_NAME} PRIVATE Qt::Core Qt::Core5Compat Qt::Widgets )

#------------------------------------------------------------------------------
# Translations

set( TS_FILES
	translations/translations_de.ts
	)

if( COMMAND qt_add_translations )
	qt_add_translations( ${PROJECT_NAME} TS_FILES ${TS_FILES} RESOURCE_PREFIX "/translations" )
else()
	qt5_create_translation( QM_FILES ${CMAKE_CURRENT_SOURCE_DIR} ${TS_FILES} )

	configure_file( ${CMAKE_SOURCE_DIR}/translations.qrc ${CMAKE_CURRENT_BINARY_DIR} COPYONLY )

	target_sources( ${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/translations.qrc ${QM_FILES} )
endif()

#------------------------------------------------------------------------------
# Unit Tests

if( FUGIO_LIBRARY_BUILD_DIR )
#add_subdirectory( tests )
endif()

set( CPACK_ARCHIVE_FUGIO-LUAQT_FILE_NAME "${PLUGIN_FILENAME}-${PLATFORM_NAME}" PARENT_SCOPE )

