cmake_minimum_required( VERSION 3.14 )

#-------------------------------------------------------------------------------
# PLUGIN DEFINES

set( PLUGIN_NAME "Lua" )
set( PLUGIN_DESCRIPTION_SHORT "Lua library" )
set( PLUGIN_DESCRIPTION_LONG "Lua library" )
set( PLUGIN_FILENAME "fugio-lua" )

set( PLUGIN_UUID "b0057f4f-7ede-4c49-a0be-c7698cb5ebaf" )
set( PLUGIN_IID "com.bigfug.fugio.lua" )

set( PLUGIN_RELEASE_VERSION "1.0.0" )
set( PLUGIN_COMPATIBILITY_VERSION "1.0.0" )
set( PLUGIN_API_COMPATIBILITY "4.0.0" )

set( PLUGIN_RELEASE_DATE "2019-10-25" )
set( PLUGIN_AUTHOR_NAME  "Alex May" )
set( PLUGIN_AUTHOR_CONTACT "https://github.com/bigfug" )

set( PLUGIN_WIKI_LINK "https://github.com/bigfug/fugio-lua/wiki/Lua_Plugin" )
set( PLUGIN_WIKI_NODE_LINK "https://github.com/bigfug/fugio-lua/wiki/Lua_Node_" )
set( PLUGIN_WIKI_PIN_LINK "https://github.com/bigfug/fugio-lua/wiki/Lua_Pin_" )

set( PLUGIN_REQUIREMENTS "\
	{ \"plugin\": \"com.bigfug.fugio.core\", \"version\": \"1.0.0\" }"
)

#-------------------------------------------------------------------------------

project( ${PLUGIN_FILENAME} VERSION ${PLUGIN_RELEASE_VERSION} LANGUAGES CXX )

set( HEADER_FILES
	include/fugio/lua/lua_interface.h
	include/fugio/lua/uuid.h
)

set( SOURCE_FILES
	source/luaplugin.cpp
	source/luaplugin.h

	source/luaarray.cpp
	source/luaarray.h
	source/luaexnode.cpp
	source/luaexnode.h
	source/luaexpin.cpp
	source/luaexpin.h
	source/luanode.cpp
	source/luanode.h

	source/syntaxhighlighterlua.cpp
	source/syntaxhighlighterlua.h
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

add_dependencies( ${PROJECT_NAME} lua )

target_include_directories( ${PROJECT_NAME} PRIVATE ${CMAKE_BINARY_DIR}/lua/include )

target_link_libraries( ${PROJECT_NAME} PRIVATE ${CMAKE_BINARY_DIR}/lua/lib/lua_shared.lib )

target_compile_definitions( ${PROJECT_NAME} PRIVATE LUA_SUPPORTED )

install( FILES
	${CMAKE_BINARY_DIR}/lua/bin/lua_shared.dll
	DESTINATION ${PATH_SHARE}/libs
	COMPONENT ${PROJECT_NAME}
)

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

set( CPACK_ARCHIVE_FUGIO-LUA_FILE_NAME "${PLUGIN_FILENAME}-${PLATFORM_NAME}" PARENT_SCOPE )

