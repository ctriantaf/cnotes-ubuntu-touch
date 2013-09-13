file(GLOB_RECURSE QML {CMAKE_CURRENT_SOURCE_DIR} *.qml)

# Make the qml files show in the QtCreator tree
add_custom_target(QmlFiles SOURCES ${QML})

install(FILES CNotes.qml DESTINATION ${CMAKE_INSTALL_PREFIX}/share/memories/qml)
install(FILES U1Backend.qml DESTINATION ${CMAKE_INSTALL_PREFIX}/share/memories/qml)
install(FILES Storage.js DESTINATION ${CMAKE_INSTALL_PREFIX}/share/memories/qml)
install(FILES showdown.js DESTINATION ${CMAKE_INSTALL_PREFIX}/share/memories/qml)
install(DIRECTORY components DESTINATION ${CMAKE_INSTALL_PREFIX}/share/memories/qml)
install(DIRECTORY pages DESTINATION ${CMAKE_INSTALL_PREFIX}/share/memories/qml)
install(DIRECTORY view DESTINATION ${CMAKE_INSTALL_PREFIX}/share/memories/qml)
