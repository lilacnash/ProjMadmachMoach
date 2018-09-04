function GUI_object = generatePlots(GUI_object, numOfPlots, numOfPlotsPerCol, numOfPlotsPerRow, containerPosition)
    handlesGUI = guihandles(GUI_object);
    POP_UP_MENU_WIDTH = 0.04;
    POP_UP_MENU_HEIGHT = 0.03;
    TITLE_HEIGHT = 0.03;
    MAX_FONT_SIZE = 16;
    TEXT_FONT_SIZE = min([MAX_FONT_SIZE,round((1/numOfPlots)*80)]);
    AXES_WIDTH = 0.04;
    AXES_HEIGHT = 0.04;
    WIDTH = ((containerPosition(3)-AXES_WIDTH)/numOfPlotsPerRow) - AXES_WIDTH;
    HEIGHT = ((containerPosition(4)-AXES_HEIGHT)/numOfPlotsPerCol) - TITLE_HEIGHT - AXES_HEIGHT;
    TITLE_WIDTH = WIDTH-POP_UP_MENU_WIDTH;
    plotContainerWidth = WIDTH+AXES_WIDTH;
    plotContainerHeight = HEIGHT+TITLE_HEIGHT+AXES_HEIGHT;
    LEFT_UPPER_CORNER = [containerPosition(1)+0.01, containerPosition(2) + containerPosition(4)];
    n=1;
    for j = 1:1:numOfPlotsPerCol
        for i = 1:1:numOfPlotsPerRow
            if n<=numOfPlots
%                 position_Axes = [containerPosition(1)+0.02+(POP_UP_MENU_WIDTH+width)*(i-1), containerPosition(2)+0.95-height*(j),width,height];
                position_Axes = [LEFT_UPPER_CORNER(1)+(plotContainerWidth*(i-1))+AXES_WIDTH, LEFT_UPPER_CORNER(2)-(plotContainerHeight*(j))+AXES_HEIGHT,WIDTH,HEIGHT];
%                 Position_PopUpMenu = [0.02+(width*i)+POP_UP_MENU_WIDTH*(i-1),0.95-height*(j),POP_UP_MENU_WIDTH,POP_UP_MENU_HEIGHT];
                Position_PopUpMenu = [LEFT_UPPER_CORNER(1)+(plotContainerWidth*(i))-POP_UP_MENU_WIDTH,LEFT_UPPER_CORNER(2)-(plotContainerHeight*(j-1))-TITLE_HEIGHT,POP_UP_MENU_WIDTH,POP_UP_MENU_HEIGHT];
                titlePosition = [LEFT_UPPER_CORNER(1)+(plotContainerWidth*(i-1))+AXES_WIDTH,LEFT_UPPER_CORNER(2)-(plotContainerHeight*(j-1))-TITLE_HEIGHT,TITLE_WIDTH,TITLE_HEIGHT];
                handlesGUI.fastPlot(n) = axes('Position',position_Axes,'Tag',['fastPlot',num2str(n)], 'Units','normalized');
                handlesGUI.fastPlotPopupmenu(n) = uicontrol('Style', 'popup','Units','normalized','Position',Position_PopUpMenu,'Tag', ['fastPlotPopupmenu',num2str(n)],'String',{''});
                handlesGUI.fastPlotTitle(n) = uicontrol('Style', 'text', 'Units','normalized', 'Position', titlePosition, 'Tag', ['fastPlotTitle',num2str(n)],'String','', 'FontSize', TEXT_FONT_SIZE);
                n = n+1;                     
            end   
        end
    end
    guidata(GUI_object,handlesGUI);
    
    
                