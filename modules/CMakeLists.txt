set(LIB DirParserPlugin)

set(SRCS
    DirParser/Plugin.cpp
    DirParser/dir_creator.cpp
)

set(HDRS
    DirParser/Plugin.h
    DirParser/dir_creator.h
)

add_library(${LIB} SHARED ${SRCS})

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${Qt5Quick_INCLUDE_DIRS}
)

target_link_libraries(${LIB}
    ${Qt5Core_LIBRARIES}
    ${Qt5Quick_LIBRARIES}
)

# copy qmldir file into build directory for shadow builds
file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/DirParser/qmldir"
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
)

## Copy the .so to the modules/ path, so it's easier to test the app locally, without installation
add_custom_command(
    TARGET ${LIB}
    POST_BUILD
    COMMAND "cp" "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB}.so" "${CMAKE_SOURCE_DIR}/modules/DirParser/"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
)

## Generate the plugins.qmltypes file, so it's easier to comunicate with QtCreator
add_custom_command(
    TARGET ${LIB}
    POST_BUILD
    COMMAND "rm" "-f" "plugins.qmltypes" ";" "qmlplugindump" "DirParser" "0.1" "${CMAKE_SOURCE_DIR}/modules" ">" "plugins.qmltypes"
    "&&" "cp" "${CMAKE_CURRENT_BINARY_DIR}/plugins.qmltypes" "${CMAKE_SOURCE_DIR}/modules/DirParser/"
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)

install(TARGETS ${LIB} DESTINATION ${MODULES_DIR})
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/plugins.qmltypes
        DESTINATION ${MODULES_DIR}
)
