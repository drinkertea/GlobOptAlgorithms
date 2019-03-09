cmake_minimum_required(VERSION 3.0.0)

set(PROJECT "StepMethods")
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_FLAGS /bigobj)

set (QT5LIBS
    Qml
    Gui
    Core
    Quick
    Charts
    Widgets
    Network
)

set (qmlQRC
    qml/qml.qrc
)

set(SOURCE
    3rdparty/exprtk.hpp
    src/main.cpp
    src/MainPresenter.h
    src/MainPresenter.cpp
    src/Algorithms.h
    src/Algorithms.cpp
)

project(${PROJECT})
find_package(Qt5 REQUIRED ${QT5LIBS})
qt5_add_resources(qml_QRC ${qmlQRC})
add_executable(${PROJECT} ${SOURCE} ${qml_QRC})
target_link_libraries(${PROJECT} Qt5::Qml Qt5::Quick Qt5::Widgets Qt5::Charts)

foreach(LIB ${QT5LIBS})
    add_custom_command(TARGET ${PROJECT} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_PREFIX_PATH}\\bin\\Qt5${LIB}.dll $<TARGET_FILE_DIR:${PROJECT}>)
    add_custom_command(TARGET ${PROJECT} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_PREFIX_PATH}\\bin\\Qt5${LIB}d.dll $<TARGET_FILE_DIR:${PROJECT}>)
    message(STATUS "Added task to copy ${CMAKE_PREFIX_PATH}\\bin\\Qt5${LIB}.dll")
endforeach()
