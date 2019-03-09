import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.12
import QtCharts 2.3
import Qt.lab.mainPresenterSingleton 1.0 as Root
import QtQuick.Controls.Styles 1.3

ApplicationWindow
{
    property int inputBarHeigth : 30
    property int leftBarItemLeftMargin : 10

    property string backgroundColor: "#2d2d2d" // "#7f277a"//"#b975b5"//"#007acc"
    property string fontColor: "#f1f1f1"
    property string lightGrayColor: "#3f3f3f"
    property string piyavskiyColor: "#009933"
    property string stronginColor: "#ff6699"

    style: ApplicationWindowStyle {
        background: Rectangle {
            color: backgroundColor
        }
    }
    color: backgroundColor
    ColumnLayout
    {
        anchors.fill: parent
        Rectangle
        {
            color: backgroundColor
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout
            {
                anchors.fill: parent
                Rectangle
                {
                    color: backgroundColor
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    ChartView {
                        ValueAxis {
                            id: axisY
                            min: Root.StepsMetods.minY
                            max: Root.StepsMetods.maxY
                            color: fontColor
                            gridLineColor : fontColor
                            labelsVisible : false
                            shadesVisible : false
                            lineVisible : false
                            titleVisible : false
                            minorGridVisible : false
                            tickCount: 2
                        }

                        ValueAxis {
                            id: axisX
                            minorTickCount: 5
                            min: Root.StepsMetods.leftEdge
                            max: Root.StepsMetods.rightEdge
                            color: fontColor
                            gridLineColor : fontColor
                            minorGridLineColor :"#007acc"
                            lineVisible : false
                            labelsColor : fontColor
                        }

                        theme: ChartView.ChartThemeQt
                        x : parent.x
                        y : parent.x
                        width: parent.width
                        height: parent.height + 14
                        id: chart
                        legend.alignment: Qt.AlignBottom
                        antialiasing: true
                        backgroundColor: lightGrayColor
                        titleColor: fontColor
                        plotAreaColor: "#3f3f46"
                        legend.visible: false
                        SplineSeries
                        {
                            axisX: axisX
                            axisY: axisY
                        }
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredHeight: 150
                    Layout.fillWidth: true
                    ChartView {
                        ValueAxis {
                            id: axisYs
                            min: -1.5
                            max: 1.5
                            color: fontColor
                            gridLineColor : fontColor
                            labelsVisible : false
                            shadesVisible : false
                            lineVisible : false
                            tickCount: 2
                        }

                        ValueAxis {
                            id: axisXs
                            minorTickCount: 5
                            min: Root.StepsMetods.leftEdge
                            max: Root.StepsMetods.rightEdge
                            color: fontColor
                            minorGridLineColor :"#007acc"
                            gridLineColor : fontColor
                            lineVisible : false
                            labelsColor : fontColor
                        }

                        theme: ChartView.ChartThemeQt
                        x : parent.x
                        y : parent.x
                        width: parent.width
                        height: parent.height + 14
                        id: stats_chart
                        legend.alignment: Qt.AlignBottom
                        antialiasing: true
                        backgroundColor: lightGrayColor
                        titleColor: fontColor
                        plotAreaColor: "#3f3f46"
                        legend.labelColor: fontColor
                        legend.color: fontColor
                        legend.borderColor : fontColor

                        ScatterSeries {
                            axisX: axisXs
                            axisY: axisYs
                            name: "Scan"
                            markerShape: ScatterSeries.MarkerShapeRectangle
                            markerSize: 2
                            borderWidth: 3
                            color: "orange"
                            borderColor: "orange"
                        }
                        ScatterSeries {
                            axisX: axisXs
                            axisY: axisYs
                            name: "Piyavskiy"
                            markerShape: ScatterSeries.MarkerShapeRectangle
                            markerSize: 2
                            borderWidth: 3
                            color: piyavskiyColor
                            borderColor: piyavskiyColor
                        }
                        ScatterSeries {
                            axisX: axisXs
                            axisY: axisYs
                            name: "Strongin"
                            markerShape: ScatterSeries.MarkerShapeRectangle
                            markerSize: 2
                            borderWidth: 3
                            color: stronginColor
                            borderColor: stronginColor
                        }
                    }
                }

            }

            Rectangle
            {
                property int chart_margin: 51
                color: "red"
                x : parent.x + chart_margin
                width: parent.width - 2 * chart_margin + 6
                id : chart_area_rect
            }

            MouseArea{
                id : area
                anchors.fill: parent
                property int maxval: Root.StepsMetods.rightEdge;
                property int minval: Root.StepsMetods.leftEdge;
                onDoubleClicked: {
                    axisX.min = Root.StepsMetods.leftEdge;
                    axisX.max = Root.StepsMetods.rightEdge;
                }

                onWheel: {
                    if (wheel.x >= chart_area_rect.x && wheel.x < (chart_area_rect.x + chart_area_rect.width) && wheel.modifiers & Qt.ControlModifier) {
                        var alfa = wheel.x / chart_area_rect.width;
                        var left = (axisX.max - axisX.min) * alfa;
                        var right = axisX.max - left;
                        var scale = 0.1
                        var min = axisX.min;
                        var max = axisX.max;
                        if (wheel.angleDelta.y < 0)
                            scale *= -1
                        min += left * scale * alfa;
                        max -= right * scale * (1.0 - alfa);
                        if (min < minval)
                            min = minval
                        if (max > maxval)
                            max = maxval
                        if (max > min)
                        {
                            axisX.min = min;
                            axisX.max = max;
                            axisXs.min = min;
                            axisXs.max = max;
                        }
                    }
                }
            }
        }
        Rectangle
        {
            Layout.preferredHeight: inputBarHeigth
            Layout.fillWidth: true
            color: backgroundColor

            RowLayout
            {
                anchors.fill: parent
                spacing: 0

                Rectangle
                {
                    id: label1_rect
                    color: backgroundColor
                    Layout.preferredWidth: 125
                    Layout.fillHeight: true
                    Label
                    {
                        color: fontColor
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: leftBarItemLeftMargin
                        anchors.left: parent.left
                        text: "Input your function:"
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: chart_area_rect.x + chart_area_rect.width / 4 - label1_rect.width + 7
                    Layout.fillHeight: true
                    Rectangle {
                        color: "#3f3f46"
                        anchors.fill: parent
                        anchors.margins: 3
                        Rectangle {
                            color: "#007acc"
                            anchors.bottom: parent.bottom
                            width: parent.width
                            x: parent.x - 3
                            height: 1
                            y : parent.y
                        }
                    }
                    TextInput
                    {
                        id: expression_textbox
                        font.pixelSize: 12
                        color: fontColor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: leftBarItemLeftMargin
                        width: parent.width - 2 * leftBarItemLeftMargin
                        layer.enabled: true
                        text: Root.StepsMetods.expression
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 107
                    Layout.fillHeight: true
                    Label
                    {
                        color: fontColor
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: leftBarItemLeftMargin/ 3
                        anchors.left: parent.left
                        text: "Input range, from:"
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    Rectangle {
                        color: "#3f3f46"
                        anchors.fill: parent
                        anchors.margins: 3
                        Rectangle {
                            color: "#007acc"
                            anchors.bottom: parent.bottom
                            width: parent.width
                            x: parent.x - 3
                            height: 1
                            y : parent.y
                        }
                    }
                    TextInput
                    {
                        id: left_textbox
                        font.pixelSize: 12
                        color: fontColor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: leftBarItemLeftMargin
                        width: parent.width - 2 * leftBarItemLeftMargin
                        layer.enabled: true
                        text: Root.StepsMetods.leftEdge
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 20
                    Layout.fillHeight: true
                    Label
                    {
                        color: fontColor
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: leftBarItemLeftMargin / 3
                        anchors.left: parent.left
                        text: "to:"
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    Rectangle {
                        color: "#3f3f46"
                        anchors.fill: parent
                        anchors.margins: 3
                        Rectangle {
                            color: "#007acc"
                            anchors.bottom: parent.bottom
                            width: parent.width
                            x: parent.x - 3
                            height: 1
                            y : parent.y
                        }
                    }
                    TextInput
                    {
                        id: right_textbox
                        font.pixelSize: 12
                        color: fontColor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: leftBarItemLeftMargin
                        width: parent.width - 2 * leftBarItemLeftMargin
                        layer.enabled: true
                        text: Root.StepsMetods.rightEdge
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 130
                    Layout.fillHeight: true
                    Label
                    {
                        color: fontColor
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: leftBarItemLeftMargin / 3
                        anchors.left: parent.left
                        text: "Input iterations count:"
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    Rectangle {
                        color: "#3f3f46"
                        anchors.fill: parent
                        anchors.margins: 3
                        Rectangle {
                            color: "#007acc"
                            anchors.bottom: parent.bottom
                            width: parent.width
                            x: parent.x - 3
                            height: 1
                            y : parent.y
                        }
                    }
                    TextInput
                    {
                        id: iter_textbox
                        font.pixelSize: 12
                        color: fontColor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: leftBarItemLeftMargin
                        width: parent.width - 2 * leftBarItemLeftMargin
                        layer.enabled: true
                        text: Root.StepsMetods.stepsCnt
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    Label
                    {
                        color: fontColor
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: leftBarItemLeftMargin / 3
                        anchors.left: parent.left
                        text: "Input coefficient:"
                    }
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    Rectangle {
                        color: "#3f3f46"
                        anchors.fill: parent
                        anchors.margins: 3
                        Rectangle {
                            color: "#007acc"
                            anchors.bottom: parent.bottom
                            width: parent.width
                            x: parent.x - 3
                            height: 1
                            y : parent.y
                        }
                    }
                    TextInput
                    {
                        id: coef_textbox
                        font.pixelSize: 12
                        color: fontColor
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: leftBarItemLeftMargin
                        width: parent.width - 2 * leftBarItemLeftMargin
                        layer.enabled: true
                        text: Root.StepsMetods.coff
                    }
                }

                Rectangle
                {
                    id: mid_rect
                    color: backgroundColor

                    Rectangle {
                        id : update_btn
                        color: "#3f3f46"
                        anchors.fill: parent
                        anchors.margins: 3
                        Rectangle {
                            color: "#007acc"
                            anchors.top: parent.top
                            width: parent.width
                            x: parent.x - 3
                            height: 1
                            y : parent.y
                        }
                        Label
                        {
                            color: fontColor
                            font.pixelSize: 12
                            anchors.centerIn: parent
                            text: "Calculate"
                        }
                        MouseArea
                        {
                            hoverEnabled: true
                            anchors.fill: parent
                            onEntered: update_btn.color = "#646464"
                            onExited: update_btn.color = "#3f3f46"
                            onClicked:
                            {
                                Root.StepsMetods.expression = expression_textbox.text
                                Root.StepsMetods.leftEdge = parseFloat(left_textbox.text)
                                Root.StepsMetods.rightEdge = parseFloat(right_textbox.text)
                                Root.StepsMetods.coff = parseFloat(coef_textbox.text)
                                Root.StepsMetods.stepsCnt = parseInt(iter_textbox.text)
                                Root.StepsMetods.updateAllSeries(chart.series(0), stats_chart.series(0),stats_chart.series(1),stats_chart.series(2));

                                axisX.min = Root.StepsMetods.leftEdge;
                                axisX.max = Root.StepsMetods.rightEdge;
                                axisY.min = Root.StepsMetods.minY;
                                axisY.max = Root.StepsMetods.maxY;
                                axisXs.min = Root.StepsMetods.leftEdge;
                                axisXs.max = Root.StepsMetods.rightEdge;
                            }
                        }
                    }
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                Rectangle
                {
                    color: backgroundColor
                    Layout.preferredWidth: leftBarItemLeftMargin
                    Layout.fillHeight: true
                }
            }
        }
    }

    visible: true
    width: 1280
    height: 720
    minimumWidth: 1280
    minimumHeight: 720
    title: qsTr("StepsMethods")

    Component.onCompleted:
    {
        expression_textbox.forceActiveFocus()
    }
}


