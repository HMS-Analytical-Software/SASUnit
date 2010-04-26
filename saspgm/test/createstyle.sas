proc template;
   define style Styles.SASUNIT;
      style fonts
         "Fonts used in the default style" /
         'TitleFont2' = ("Geneva, Arial, Helvetica, sans-serif",4,Bold Italic)
         'TitleFont' = ("Geneva, Arial, Helvetica, sans-serif",5,Bold Italic)
         'StrongFont' = ("Geneva, Arial, Helvetica, sans-serif",2,Bold)
         'EmphasisFont' = ("Geneva, Arial, Helvetica, sans-serif",2,Italic)
         'FixedEmphasisFont' = ("Geneva, Arial, Helvetica, sans-serif",2,Italic)
         'FixedStrongFont' = ("Geneva, Arial, Helvetica, sans-serif",2,Bold)
         'FixedHeadingFont' = ("Geneva, Arial, Helvetica, sans-serif",2)
         'BatchFixedFont' = ("Geneva, Arial, Helvetica, sans-serif", 2)
         'FixedFont' = ("Geneva, Arial, Helvetica, sans-serif",2)
         'headingEmphasisFont' = ("Geneva, Arial, Helvetica, sans-serif",2,Bold Italic)
         'headingFont' = ("Geneva, Arial, Helvetica, sans-serif",2,Bold)
         'docFont' = ("Geneva, Arial, Helvetica, sans-serif",2);
      style GraphFonts
         "Fonts used in graph styles" /
         'GraphDataFont' = ("Arial",8pt)
         'GraphValueFont' = ("Arial",10pt)
         'GraphLabelFont' = ("Arial",12pt,Bold)
         'GraphFootnoteFont' = ("Arial",12pt,Bold)
         'GraphTitleFont' = ("Arial",14pt,Bold);
      style color_list
         "Colors used in the default style" /
         'fgB2' = cx0066AA
         'fgB1' = cx004488
         'fgA4' = cxAAFFAA
         'bgA4' = white
         'bgA3' = cxe8eef2
         'fgA2' = cx0033AA
         'bgA2' = cxe8eef2
         'fgA1' = cx000000
         'bgA1' = white
         'fgA' = cx002288
         'bgA' = white;
      style colors
         "Abstract colors used in the default style" /
         'headerfgemph' = color_list('fgA2')
         'headerbgemph' = cxd7dde1
         'headerfgstrong' = color_list('fgA2')
         'headerbgstrong' = cxd7dde1
         'headerfg' = color_list('fgA2')
         'headerbg' = cxd7dde1
         'datafgemph' = color_list('fgA1')
         'databgemph' = color_list('bgA3')
         'datafgstrong' = color_list('fgA1')
         'databgstrong' = color_list('bgA3')
         'datafg' = color_list('fgA1')
         'databg' = color_list('bgA3')
         'batchfg' = color_list('fgA1')
         'batchbg' = color_list('bgA3')
         'tableborder' = cxCCCCCC
         'tablebg' = color_list('bgA1')
         'notefg' = color_list('fgA')
         'notebg' = color_list('bgA')
         'bylinefg' = color_list('fgA2')
         'bylinebg' = color_list('bgA2')
         'captionfg' = color_list('fgA1')
         'captionbg' = color_list('bgA')
         'proctitlefg' = color_list('fgA')
         'proctitlebg' = color_list('bgA')
         'titlefg' = color_list('fgA')
         'titlebg' = color_list('bgA')
         'systitlefg' = black
         'systitlebg' = color_list('bgA')
         'Conentryfg' = color_list('fgA2')
         'Confolderfg' = color_list('fgA')
         'Contitlefg' = color_list('fgA')
         'link2' = color_list('fgB2')
         'link1' = color_list('fgB1')
         'contentfg' = color_list('fgA2')
         'contentbg' = color_list('bgA2')
         'docfg' = color_list('fgA')
         'docbg' = color_list('bgA');
      style GraphColors
         "Abstract colors used in graph styles" /
         'gcerror' = cx000000
         'gerror' = cxB9CFE7
         'gcpredictlim' = cx003178
         'gpredictlim' = cxB9CFE7
         'gcpredict' = cx003178
         'gpredict' = cx003178
         'gcconfidence' = cx003178
         'gconfidence' = cxB9CFE7
         'gcfit' = cx003178
         'gfit' = cx003178
         'gcoutlier' = cx000000
         'goutlier' = cxB9CFE7
         'gcdata' = cx000000
         'gdata' = cxB9CFE7
         'ginsetheader' = colors('docbg')
         'ginset' = cxFFFFFF
         'greferencelines' = cx808080
         'gheader' = colors('docbg')
         'gconramp3cend' = cxFF0000
         'gconramp3cneutral' = cxFF00FF
         'gconramp3cstart' = cx0000FF
         'gramp3cend' = cxDD6060
         'gramp3cneutral' = cxFFFFFF
         'gramp3cstart' = cx6497EB
         'gconramp2cend' = cx6497EB
         'gconramp2cstart' = cxFFFFFF
         'gramp2cend' = cx5E528B
         'gramp2cstart' = cxFFFFFF
         'gtext' = cx000000
         'glabel' = cx000000
         'gborderlines' = cx000000
         'goutlines' = cx000000
         'ggrid' = cx808080
         'gaxis' = cx000000
         'gshadow' = cx000000
         'glegend' = cxFFFFFF
         'gfloor' = cxFFFFFF
         'gwalls' = cxFFFFFF
         'gcdata12' = cxF7AC4E
         'gcdata11' = cxB38EF3
         'gcdata10' = cx47A82A
         'gcdata9' = cxC08A13
         'gcdata8' = cx2597FA
         'gcdata7' = cxB26084
         'gcdata6' = cx7F8E1F
         'gcdata5' = cx9D3CDB
         'gcdata4' = cxC1161C
         'gcdata3' = cx426952
         'gcdata2' = cx763810
         'gcdata1' = cx2A25D9
         'gdata12' = cx7F5934
         'gdata11' = cxC8573C
         'gdata10' = cx679920
         'gdata9' = cx5E528B
         'gdata8' = cxD6C66E
         'gdata7' = cxB87F32
         'gdata6' = cx6F7500
         'gdata5' = cx8AA4C9
         'gdata4' = cxFDC861
         'gdata3' = cx98341C
         'gdata2' = cx8DA642
         'gdata1' = cx6173A9;
      style html
         "Common HTML text used in the default style" /
         'expandAll' = "<span onclick=""if(msie4==1)expandAll()"">"
         'posthtml flyover line' = "</span><hr size=""3"">"
         'prehtml flyover line' = "<span><hr size=""3"">"
         'prehtml flyover bullet' = %nrstr("<span><b>&#183;</b>")
         'posthtml flyover' = "</span>"
         'prehtml flyover' = "<span>"
         'break' = "<br>"
         'Line' = "<hr size=""3"">"
         'PageBreakLine' =                                                    
         "<p style=""page-break-after: always;""><br></p><hr size=""3"">"
         'fake bullet' = %nrstr("<b>&#183;</b>");
      style text
         "Common text." /
         'Fatal Banner' = "Fatal:"
         'Error Banner' = "Error:"
         'Warn Banner' = "Warning:"
         'Note Banner' = "Note:"
         'Pages Title' = "Table of Pages"
         'Content Title' = "Table of Contents"
         'suffix1' = " Procedure"
         'prefix1' = "The ";
      style StartUpFunction
         "Controls the StartUp Function. TAGATTR is only element used.";
      style ShutDownFunction
         "Controls the Shut-Down Function. TAGATTR is only element used.";
      style Container
         "Abstract. Controls all container oriented elements." /
         font = Fonts('DocFont')
         foreground = colors('docfg')
         background = colors('docbg');
      style Index from Container
         "Abstract. Controls Contents and Pages." /
         foreground = colors('contentfg')
         background = colors('contentbg');
      style Document from Container
         "Abstract. Controls the various document bodies." /
         htmldoctype =
         "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 3.2 Final//EN"">"
         htmlcontenttype = "text/html"
         protectspecialchars = auto
         linkcolor = colors('link2')
         activelinkcolor = colors('link1')
         visitedlinkcolor = colors('link1');
      style Body from Document
         "Controls the Body file." /
         rightmargin = 8
         leftmargin = 8
         pagebreakhtml = html('PageBreakLine');
      style Frame from Document
         "Controls the Frame file." /
         contentposition = L
         bodyscrollbar = auto
         bodysize = *
         contentscrollbar = auto
         contentsize = 23%
         framespacing = 1
         frameborderwidth = 4
         frameborder = on;
      style Contents from Document
         "Controls the Contents file." /
         bullet = "decimal"
         tagattr = " onload=""if (msie4 == 1)expandAll()"""
         pagebreakhtml = html('break')
         foreground = colors('contentfg')
         background = colors('contentbg')
         rightmargin = 8
         leftmargin = 8;
      style Pages from Document
         "Controls the Pages file." /
         bullet = "decimal"
         tagattr = " onload=""if (msie4 == 1)expandAll()"""
         pagebreakhtml = html('break')
         foreground = colors('contentfg')
         background = colors('contentbg')
         rightmargin = 8                   
         leftmargin = 8;
      style Date from Container
         "Abstract. Controls how date fields look." /
         outputwidth = 100%
         background = colors('contentbg')
         foreground = colors('contentfg');
      style BodyDate from Date
         "Controls the date field in the Body file." /
         vjust = T
         just = R
         cellspacing = 0
         cellpadding = 0
         background = colors('docbg')
         foreground = colors('docfg');
      style ContentsDate from Date
         "Controls the date in the Contents file.";
      style PagesDate from Date                                               
         "Controls the date in the Pages file.";
      style IndexItem from Container                                          
         "Abstract. Controls list items and folders for Contents and Pages." /
         leftmargin = 6pt                                                     
         posthtml = html('posthtml flyover')
         prehtml = html('prehtml flyover bullet')
         listentryanchor = on                                                 
         bullet = NONE                                                        
         background = _undef_                                                 
         foreground = colors('conentryfg');
      style ContentFolder from IndexItem                                      
         "Controls the generic folder definition in the Contents file." /
         listentryanchor = off                                                
         foreground = colors('confolderfg');
      style ByContentFolder from ContentFolder                                
         "Controls the byline folder in the Contents file.";
      style ContentItem from IndexItem                                        
         "Controls the leafnode item in the Contents file.";
      style PagesItem from IndexItem                                          
         "Controls the leafnode item in the Pages file.";
      style IndexProcName from Index                                          
         "Abstract. Controls the proc name in the list files." /
         listentryanchor = off                                                
         bullet = "decimal"                                                   
         posthtml = html('posthtml flyover')
         prehtml = html('prehtml flyover')
         posttext = text('suffix1')
         pretext = text('prefix1')
         background = _undef_                                                 
         foreground = colors('contitlefg');
      style ContentProcName from IndexProcName                                
         "Controls the proc name in the Contents file.";
      style ContentProcLabel from ContentProcName                             
         "Controls the proc label in the Contents file." /
         posttext = _undef_                                                   
         pretext = _undef_;
      style PagesProcName from IndexProcName                                  
         "Controls the proc name in the Pages file.";
      style PagesProcLabel from PagesProcName                                 
         "Controls the proc label in the Pages file." /
         posttext = _undef_                                                   
         pretext = _undef_;
      style IndexAction from IndexItem                                        
         "Abstract. Determines what happens on mouse-over events for folders and items.";
      style FolderAction from IndexAction                                     
         "Determines what happens on mouse-over events for folders.";
      style IndexTitle from Index                                             
         "Abstract. Controls the title of Contents and Pages files." /
         posthtml = html('posthtml flyover line')
         prehtml = html('expandAll')
         font = fonts('EmphasisFont')
         background = _undef_                                                 
         foreground = colors('contitlefg');
      style ContentTitle from IndexTitle                                      
         "Controls the title of the Contents file." /
         pretext = text('content title');
      style PagesTitle from IndexTitle                                        
         "Controls the title of the Pages file." /
         pretext = text('pages title');
      style SysTitleAndFooterContainer from Container                         
         "Controls container for system page title and system page footer." /
         rules = NONE                                                         
         frame = VOID                                                         
         outputwidth = 100%                                                   
         cellpadding = 1                                                      
         cellspacing = 1                                                      
         borderwidth = 0;
      style TitleAndNoteContainer from Container                              
         "Controls container for procedure defined titles and notes." /
         rules = NONE                                                         
         frame = VOID                                                         
         outputwidth = 100%                                                   
         cellpadding = 1                                                      
         cellspacing = 1                                                      
         borderwidth = 0;
      style TitlesAndFooters from Container                                   
         "Abstract. Controls system page title text and system page footer text." /
         font = Fonts('TitleFont2')
         background = colors('systitlebg')
         foreground = colors('systitlefg');
      style BylineContainer from Container                                    
         "Controls container for the byline." /
         background = colors('Docbg')
         rules = NONE                                                         
         frame = VOID                                                         
         outputwidth = 100%                                                   
         cellpadding = 1                                                      
         cellspacing = 1                                                      
         borderwidth = 0;
      style SystemTitle from TitlesAndFooters                                 
         "Controls system title text." /
         font = Fonts('TitleFont');
      style SystemFooter from TitlesAndFooters                                
         "Controls system footer text." /
         font = Fonts('TitleFont');
      style PageNo from TitlesAndFooters                                      
         "Controls page numbers for printer" /
         vjust = T                                                            
         just = R                                                             
         cellspacing = 0                                                      
         cellpadding = 0                                                      
         font = fonts('strongFont');
      style ExtendedPage from TitlesAndFooters                                
         "Msg when page won't fit." /
         just = C                                                             
         cellpadding = 2pt                                                    
         borderwidth = 1pt                                                    
         fillrulewidth = 0.5pt                                                
         posttext = ", which would not fit on a single physical page"         
         pretext = "Continuing contents of page "                             
         frame = box                                                          
         font = fonts('EmphasisFont');
      style Byline from TitlesAndFooters                                      
         "Controls byline text." /
         cellspacing = 0                                                      
         cellpadding = 0                                                      
         font = fonts('headingFont')
         background = colors('bylinebg')
         foreground = colors('bylinefg');
      style ProcTitle from TitlesAndFooters                                   
         "Controls procedure title text." /
         background = colors('proctitlebg')
         foreground = colors('proctitlefg');
      style ProcTitleFixed from ProcTitle                                     
         "Controls procedure title text, fixed font." /
         font = fonts('FixedStrongFont');
      style Output from Container                                             
         "Abstract. Controls basic output forms." /
         background = colors('tablebg')
         rules = ALL                                                       
         frame = box                                                          
         cellpadding = 7                                                      
         cellspacing = 1                                                    
         bordercolor = colors('tableborder')
         borderwidth = 1;
      style Table from Output                                                 
         "Controls overall table style." /
         cellpadding = 2px
         Borderwidth=0;
      style Batch from Output                                                 
         "Controls batch mode output." /
         font = fonts('BatchFixedFont')
         foreground = colors('batchfg')
         background = colors('batchbg');
      style Note from Container                                               
         "Abstract. Controls the container for note banners and note contents." /
         background = colors('notebg')
         foreground = colors('notefg');
      style NoteBanner from Note                                              
         "Controls the banner for NOTE:s." /
         font_weight = Bold                                                   
         pretext = text('Note Banner');
      style NoteContent from Note                                             
         "Controls the contents for NOTE:s.";
      style UserText from Note                                                
         "Controls the TEXT= style";
      style NoteContentFixed from NoteContent                                 
         "Controls the contents for NOTE:s. Fixed font." /
         font = fonts('FixedFont');
      style WarnBanner from Note                                              
         "Controls the banner for WARNING:s." /
         font_weight = Bold                                                   
         pretext = text('Warn Banner');
      style WarnContent from Note                                             
         "Controls the contents of WARNING:s.";
      style WarnContentFixed from WarnContent                                 
         "Controls the contents for WARNING:s. Fixed font." /
         font = fonts('FixedFont');
      style ErrorBanner from Note                                             
         "Controls the banner for ERROR:s." /
         font_weight = Bold                                                   
         pretext = text('Error Banner');
      style ErrorContent from Note                                            
         "Controls the contents of ERROR:s.";
      style ErrorContentFixed from ErrorContent                               
         "Controls the contents for ERROR:s. Fixed font." /
         font = fonts('FixedFont');
      style FatalBanner from Note                                             
         "Controls the banner for FATAL:s." /
         font_weight = Bold                                                   
         pretext = text('Fatal Banner');
      style FatalContent from Note                                            
         "Controls the contents of FATAL:s.";
      style FatalContentFixed from FatalContent                               
         "Controls the contents for FATAL:s. Fixed font." /
         font = fonts('FixedFont');
      style Cell from Container                                               
         "Abstract. Controls general cells." /
         cellpadding   = 2px
         ;
      style Data from Cell                                                    
         "Default style for data cells in columns." /
         foreground  = cx000080                                        
         background  = colors('databg')
         borderwidth = 1px
         bordercolor = colors('tableborder')
         ;
      style DataFixed from Data                                               
         "Default style for data cells in columns. Fixed font." /
         font = fonts('FixedFont');
      style DataEmpty from Data                                               
         "Controls empty data cells in columns.";
      style DataEmphasis from Data                                            
         "Controls emphasized data cells in columns." /
         foreground = colors('datafgemph')
         background = colors('databgemph')
         font = fonts('EmphasisFont');
      style DataEmphasisFixed from DataEmphasis                               
         "Controls emphasized data cells in columns. Fixed font." /
         font = fonts('FixedEmphasisFont');
      style DataStrong from Data                                              
         "Controls strong (more emphasized)data cells in columns." /
         foreground = colors('datafgstrong')
         background = colors('databgstrong')
         font = fonts('StrongFont');
      style DataStrongFixed from DataStrong                                   
         "Controls strong (more emphasized)data cells in columns. Fixed font." /
         font = fonts('FixedStrongFont');
      style TableHeaderContainer from Container                               
         " Box around all column headers. " /
         abstract   = on;
      style TableFooterContainer from Container                               
         " Box around all column footers. " /
         abstract = on;
      style ColumnGroup from Container                                        
         " Box around groups of columns.  This corresponds to RULES=GROUPS " /
         abstract = on;
      style HeadersAndFooters from Cell                                       
         "Abstract. Controls table headers and footers." /
         font = fonts('HeadingFont')
         foreground = colors('headerfg')
         background = colors('headerbg');
      style Caption from HeadersAndFooters                                    
         "Abstract. Controls caption field in proc tabulate." /
         cellspacing = 0                                                      
         cellpadding = 0                                                      
         foreground = colors('captionfg')
         background = colors('captionbg');
      style BeforeCaption from Caption                                        
         "Caption that comes before a table.";
      style AfterCaption from Caption                                         
         "Caption that comes after a table.";
      style Header from HeadersAndFooters                                     
         "Controls the headers of a table." /
         foreground=black;
      style HeaderFixed from Header                                           
         "Controls the header of a table. Fixed font." /
         font = fonts('FixedFont');
      style HeaderEmpty from Header                                           
         "Controls empty table header cells.";
      style HeaderEmphasis from Header                                        
         "Controls emphasized table header cells." /
         foreground = colors('headerfgemph')
         background = colors('headerbgemph')
         font = fonts('EmphasisFont');
      style HeaderEmphasisFixed from HeaderEmphasis                           
         "Controls emphasized table header cells. Fixed font." /
         font = fonts('FixedEmphasisFont');
      style HeaderStrong from Header                                          
         "Controls strong (more emphasized)table header cells." /
         foreground = colors('headerfgstrong')
         background = colors('headerbgstrong')
         font = fonts('StrongFont');
      style HeaderStrongFixed from HeaderStrong                               
         "Controls strong (more emphasized)table header cells. Fixed font." /
         font = fonts('FixedStrongFont');
      style RowHeader from Header                                             
         "Controls row headers." /
         background = color_list('bgA3');
      style RowHeaderFixed from RowHeader                                     
         "Controls row headers. Fixed font." /
         font = fonts('FixedFont');
      style RowHeaderEmpty from RowHeader                                     
         "Controls empty row headers.";
      style RowHeaderEmphasis from RowHeader                                  
         "Controls emphasized row headers." /
         font = fonts('EmphasisFont');
      style RowHeaderEmphasisFixed from RowHeaderEmphasis                     
         "Controls emphasized row headers. Fixed font." /
         font = fonts('FixedEmphasisFont');
      style RowHeaderStrong from RowHeader                                    
         "Controls strong (more emphasized)row headers." /
         font = fonts('StrongFont');
      style RowHeaderStrongFixed from RowHeaderStrong                         
         "Controls strong (more emphasized)row headers. Fixed font." /
         font = fonts('FixedStrongFont');
      style Footer from HeadersAndFooters                                     
         "Controls table footers.";
      style FooterFixed from Footer                                           
         "Controls table footers. Fixed font." /
         font = fonts('FixedFont');
      style FooterEmpty from Footer                                           
         "Controls empty table footers.";
      style FooterEmphasis from Footer                                        
         "Controls emphasized table footers." /
         font = fonts('EmphasisFont');
      style FooterEmphasisFixed from FooterEmphasis                           
         "Controls emphasized table footers. Fixed font." /
         font = fonts('FixedEmphasisFont');
      style FooterStrong from Footer                                          
         "Controls strong (more emphasized)table footers." /
         font = fonts('StrongFont');
      style FooterStrongFixed from FooterStrong                               
         "Controls strong (more emphasized)table footers. Fixed font." /
         font = fonts('FixedStrongFont');
      style RowFooter from Footer                                             
         "Controls a row footer (label).";
      style RowFooterFixed from RowFooter                                     
         "Controls a row footer (label). Fixed font." /
         font = fonts('FixedFont');
      style RowFooterEmpty from RowFooter                                     
         "Controls an empty row footer (label).";
      style RowFooterEmphasis from RowFooter                                  
         "Controls an emphasized row footer (label)." /
         font = fonts('EmphasisFont');
      style RowFooterEmphasisFixed from RowFooterEmphasis                     
         "Controls an emphasized row footer (label). Fixed font." /
         font = fonts('FixedEmphasisFont');
      style RowFooterStrong from RowFooter                                    
         "Controls a strong (more emphasized)row footer (label)." /
         font = fonts('StrongFont');
      style RowFooterStrongFixed from RowFooterStrong                         
         "Controls a strong (more emphasized)row footer (label). Fixed font." /
         font = fonts('FixedStrongFont');
      style Graph from Output                                                 
         "Control rudimentary graph output." /
         cellpadding = 0                                                      
         background = colors('docbg');
      style GraphComponent /
         abstract = on;
      style GraphCharts from GraphComponent;
      style GraphWalls from GraphComponent /
         background = GraphColors('gwalls');
      style GraphAxisLines from GraphComponent /
         foreground = GraphColors('gaxis');
      style GraphGridLines from GraphComponent /
         foreground = GraphColors('ggrid');
      style GraphOutlines from GraphComponent /
         foreground = GraphColors('goutlines');
      style GraphBorderLines from GraphComponent /
         foreground = GraphColors('gborderlines');
      style GraphReferenceLines from GraphComponent /
         foreground = GraphColors('greferencelines');
      style GraphTitleText from GraphComponent /
         font = GraphFonts('GraphTitleFont')
         foreground = GraphColors('gtext');
      style GraphFootnoteText from GraphComponent /
         font = GraphFonts('GraphFootnoteFont')
         foreground = GraphColors('gtext');
      style GraphDataText from GraphComponent /
         font = GraphFonts('GraphDataFont')
         foreground = GraphColors('gtext');
      style GraphLabelText from GraphComponent /
         font = GraphFonts('GraphLabelFont')
         foreground = GraphColors('glabel');
      style GraphValueText from GraphComponent /
         font = GraphFonts('GraphValueFont')
         foreground = GraphColors('gtext');
      style GraphBackground from GraphComponent /
         background = colors('docbg');
      style GraphFloor from GraphComponent /
         background = GraphColors('gfloor');
      style GraphLegendBackground from GraphComponent /
         background = GraphColors('glegend');
      style GraphHeaderBackground from GraphComponent /
         background = GraphColors('gheader');
      style DropShadowStyle from GraphComponent /
         foreground = GraphColors('gshadow');
      style GraphDataDefault from GraphComponent /
         markersymbol = "circle"                                              
         linestyle = 1                                                        
         contrastcolor = GraphColors('gcdata')
         foreground = GraphColors('gdata');
      style GraphData1 from GraphComponent /
         contrastcolor = GraphColors('gcdata1')
         foreground = GraphColors('gdata1');
      style GraphData2 from GraphComponent /
         contrastcolor = GraphColors('gcdata2')
         foreground = GraphColors('gdata2');
      style GraphData3 from GraphComponent /
         contrastcolor = GraphColors('gcdata3')
         foreground = GraphColors('gdata3');
      style GraphData4 from GraphComponent /
         contrastcolor = GraphColors('gcdata4')
         foreground = GraphColors('gdata4');
      style GraphData5 from GraphComponent /
         contrastcolor = GraphColors('gcdata5')
         foreground = GraphColors('gdata5');
      style GraphData6 from GraphComponent /
         contrastcolor = GraphColors('gcdata6')
         foreground = GraphColors('gdata6');
      style GraphData7 from GraphComponent /
         contrastcolor = GraphColors('gcdata7')
         foreground = GraphColors('gdata7');
      style GraphData8 from GraphComponent /
         contrastcolor = GraphColors('gcdata8')
         foreground = GraphColors('gdata8');
      style GraphData9 from GraphComponent /
         contrastcolor = GraphColors('gcdata9')
         foreground = GraphColors('gdata9');
      style GraphData10 from GraphComponent /
         contrastcolor = GraphColors('gcdata10')
         foreground = GraphColors('gdata10');
      style GraphData11 from GraphComponent /
         contrastcolor = GraphColors('gcdata11')
         foreground = GraphColors('gdata11');
      style GraphData12 from GraphComponent /
         contrastcolor = GraphColors('gcdata12')
         foreground = GraphColors('gdata12');
      style TwoColorRamp from GraphComponent /
         endcolor = GraphColors('gramp2cend')
         startcolor = GraphColors('gramp2cstart');
      style TwoColorAltRamp from GraphComponent /
         endcolor = GraphColors('gconramp2cend')
         startcolor = GraphColors('gconramp2cstart');
      style ThreeColorRamp from GraphComponent /
         endcolor = GraphColors('gramp3cend')
         neutralcolor = GraphColors('gramp3cneutral')
         startcolor = GraphColors('gramp3cstart');
      style ThreeColorAltRamp from GraphComponent /
         endcolor = GraphColors('gconramp3cend')
         neutralcolor = GraphColors('gconramp3cneutral')
         startcolor = GraphColors('gconramp3cstart');
      style StatGraphInsetBackground from GraphComponent /
         transparency = .25                                                   
         background = GraphColors('ginset');
      style StatGraphInsetHeaderBackground from GraphComponent /
         transparency = .25                                                   
         background = GraphColors('ginsetheader');
      style StatGraphData from GraphComponent /
         markersymbol = "circlefilled"                                        
         linestyle = 1                                                        
         contrastcolor = GraphColors('gcdata')
         foreground = GraphColors('gdata');
      style StatGraphOutlierData from GraphComponent /
         markersize = 3px                                                     
         markersymbol = "X"                                                   
         transparency = 0.00                                                  
         contrastcolor = GraphColors('gcoutlier')
         foreground = GraphColors('goutlier');
      style StatGraphFitLine from GraphComponent /
         transparency = 0.00                                                  
         linethickness = 2px                                                  
         linestyle = 1                                                        
         contrastcolor = GraphColors('gcfit')
         foreground = GraphColors('gfit');
      style StatGraphConfidence from GraphComponent                           
         "Foreground for band fill;ContrastColor for lines" /
         transparency = 0.50                                                  
         linethickness = 1px                                                  
         linestyle = 34                                                       
         contrastcolor = GraphColors('gcconfidence')
         foreground = GraphColors('gconfidence');
      style StatGraphPredictionLines from GraphComponent /
         transparency = 0.00                                                  
         linethickness = 3px                                                  
         linestyle = 35                                                       
         contrastcolor = GraphColors('gcpredict')
         foreground = GraphColors('gpredict');
      style StatGraphPredictionLimit from GraphComponent /
         transparency = 0.00                                                  
         contrastcolor = GraphColors('gcpredictlim')
         foreground = GraphColors('gpredictlim');
      style StatGraphError from GraphComponent                                
         "Foreground for error fill;ContrastColor for lines" /
         transparency = 0.00                                                  
         linethickness = 1px                                                  
         linestyle = 5                                                        
         contrastcolor = GraphColors('gcerror')
         foreground = GraphColors('gerror');
      style LayoutContainer from GraphComponent                               
         "Container for LAYOUT" /
         cellpadding = 0                                                      
         cellspacing = 30                                                     
         borderwidth = 0                                                      
         frame = void                                                         
         rules = none                                                         
         background = _undef_;
      style LayoutRegion from LayoutContainer                                 
         "Region style for LAYOUT cells";
   end;
run;
ods listing close;
* reading Stylesheet *;
*ods html(1)file="C:\TEMP\SASUNIT_HTML.html" /*style=styles.sasunit*/stylesheet=(url="SAS_SASUnit.css");
*ods htmlcss(2)file="C:\TEMP\SASUNIT_HTMLCSS.html" /*style=styles.sasunit*/stylesheet=(url="SAS_SASUnit.css");
*ods html(3)file="C:\TEMP\SASUNIT_HTML_mit_Styleangabe.html" style=styles.sasunit stylesheet=(url="SAS_SASUnit.css");
*ods htmlcss(4)file="C:\TEMP\SASUNIT_HTMLCSS_mit_Styleangabe.html" style=styles.sasunit stylesheet=(url="SAS_SASUnit.css");
* writing Stylesheet *;
ods html(5)file="C:\TEMP\SASUNIT.html" style=styles.sasunit stylesheet="C:\TEMP\SAS_SASUnit.css";
proc print data=sashelp.class (obs=3);
run;
proc report data=sashelp.class (obs=3)nowd missing;
   columns name sex age height weight;
   define name /id style={font_weight=bold};
run;
ods _all_ close;
ods listing;
