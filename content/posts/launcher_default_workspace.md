+++
date = '2025-02-28T00:32:54+08:00'
title = 'Launcher_default_workspace'
+++

# Launcher3 default workspace

## 1. config file

**default_workspace_4x5.xml**

```xml
<favorites xmlns:launcher="http://schemas.android.com/apk/res-auto/com.android.launcher3">

    <!-- Hotseat (We use the screen as the position of the item in the hotseat) -->
    <!-- Dialer, Messaging, Browser, Camera -->
    <resolve
        launcher:container="-101"
        launcher:screen="0"
        launcher:x="0"
        launcher:y="0" >
        <favorite
            launcher:className="com.android.contacts.activities.TwelveKeyDialer"
            launcher:packageName="com.android.contacts" />
        <favorite launcher:uri="#Intent;action=android.intent.action.DIAL;end" />
        <favorite launcher:uri="tel:123" />
        <favorite launcher:uri="#Intent;action=android.intent.action.CALL_BUTTON;end" />
    </resolve>

    <resolve
        launcher:container="-101"
        launcher:screen="1"
        launcher:x="1"
        launcher:y="0" >
        <favorite launcher:uri="#Intent;action=android.intent.action.MAIN;category=android.intent.category.APP_MESSAGING;end" />
        <favorite launcher:uri="sms:" />
        <favorite launcher:uri="smsto:" />
        <favorite launcher:uri="mms:" />
        <favorite launcher:uri="mmsto:" />
    </resolve>
```

attrs.xml

```xml
<!-- XML attributes used by default_workspace.xml -->
<declare-styleable name="Favorite">
    <attr name="className" format="string" />
    <attr name="packageName" format="string" />
    <attr name="container" format="string" />
    <attr name="screen" format="string" />
    <attr name="x" format="string" />
    <attr name="y" format="string" />
    <attr name="spanX" format="string" />
    <attr name="spanY" format="string" />
    <attr name="icon" format="reference" />
    <attr name="title" format="string" />
    <attr name="uri" format="string" />
</declare-styleable>
```

1. className (format="string")

   - Purpose: Specifies the fully qualified class name of the activity or component that should be launched when the favorite item is tapped.

   - Example: com.google.android.apps.messaging.ui.ConversationListActivity
   - Usage: This is used to identify the specific activity within an app that should be launched.
2. packageName (format="string")
   - Purpose: Specifies the package name of the app that the favorite item belongs to.
   - Example: com.google.android.apps.messaging
   - Usage: This is used to identify the app that the favorite item is associated with.
3. container (format="string")

   - Purpose: Specifies the container where the favorite item is located.
     Values:

        - **-100: Represents the user's desktop.**

        - **-101: Represents the Hotseat.**

        - **Other negative values: Represent folders.**

    - Usage: This is used to determine whether the item is on the home screen, in the Hotseat, or in a folder.
4. screen (format="string")
   - Purpose: Specifies the screen number where the favorite item is located.
     Values:
         - **-1: Represents the Hotseat.**
         - **0, 1, 2, etc.: Represent the different home screen pages.**
   - Usage: This is used to determine which home screen page or the Hotseat the item is on.

5. x (format="string")
   - Purpose: Specifies the horizontal position (column) of the favorite item within its container (e.g., on the home screen grid or in the Hotseat).
   - Usage: This is used to determine the item's horizontal position.

6. y (format="string")
   - Purpose: Specifies the vertical position (row) of the favorite item within its container (e.g., on the home screen grid).
   - Usage: This is used to determine the item's vertical position.

7. spanX (format="string")
   - Purpose: Specifies the horizontal span (width) of the favorite item, in terms of grid cells.
   - Usage: This is used for widgets that occupy more than one grid cell horizontally.

8. spanY (format="string")
   - Purpose: Specifies the vertical span (height) of the favorite item, in terms of grid cells.
   - Usage: This is used for widgets that occupy more than one grid cell vertically.

9. icon (format="reference") 
   - Purpose: Specifies a drawable resource to be used as the icon for the favorite item.
   - Example: @drawable/my_app_icon
   - Usage: This is used to override the default icon for an app or shortcut.

10. title (format="string")
    - Purpose: Specifies the title or label to be displayed for the favorite item.
    - Usage: This is used to override the default app name or to provide a custom label for a shortcut.

11. uri (format="string")
    - Purpose: Specifies a URI (Uniform Resource Identifier) associated with the favorite item.
    - Usage: This is used for shortcuts that launch specific content or actions, such as a web page or a contact.

## 2. DefaultLayoutParser -> AutoInstallsLayout

> Here's a breakdown of the flow, from the start of the parsing process to the creation of the default workspace:
> 1. **Launcher Initialization:**
>   - Launcher.onCreate(): The Launcher activity's onCreate() method is called when the launcher starts.
>   - LauncherModel: The Launcher creates an instance of LauncherModel. The LauncherModel is responsible for loading the data that will be displayed on the home screen.
>   - startLoader(): The LauncherModel starts the loading process by calling startLoader().
>     
> 2. **Loading the Workspace:**
>   - loadWorkspace(): The LauncherModel calls loadWorkspace() to start loading the workspace.
>   - loadDefaultFavorites(): Inside loadWorkspace(), the loadDefaultFavorites() method is called. This is where the parsing of default_workspace.xml begins.
>     
> 3. **Parsing default_workspace.xml:**
>   - XmlResourceParser: An XmlResourceParser is created to read the default_workspace.xml file.
>   - Resources.getXml(): The Resources.getXml() method is used to get the XmlResourceParser for the default_workspace.xml resource.
>   - XmlPullParser: The XmlResourceParser implements the XmlPullParser interface, which allows for efficient parsing of XML data.
>   - Event-Based Parsing: The XmlPullParser uses an event-based parsing model. It generates events (e.g., START_TAG, END_TAG, TEXT) as it reads the XML data.
>   - Looping Through Events: The code loops through the events generated by the XmlPullParser.
>   - START_TAG: When a START_TAG event is encountered, the code checks the tag name.
>   - <favorites>: If the tag name is <favorites>, the code continues to the next event.
>   - <favorite>: If the tag name is <favorite>, the code extracts the attributes from the tag.
>   - Extracting Attributes: The code uses methods like getAttributeValue() to extract the values of the attributes (e.g., packageName, className, container, screen, x, y, etc.).
>   - ItemInfo: An ItemInfo object is created to store the information about the favorite item.
>   - ShortcutInfo: If the item is an app icon or shortcut, a ShortcutInfo object is created.
>   - AppWidgetProviderInfo: If the item is a widget, an AppWidgetProviderInfo object is created.
>     FolderInfo: If the item is a folder, a FolderInfo object is created.
>   - Adding to List: The ItemInfo object is added to a list of items to be added to the workspace.
>   - <appwidget>: If the tag name is <appwidget>, the code extracts the attributes for the widget.
>   - <folder>: If the tag name is <folder>, the code extracts the attributes for the folder.
>   - END_TAG: When an END_TAG event is encountered, the code checks if it's the end of a
>   - <favorite>, <appwidget>, or <folder> tag.
>   - END_DOCUMENT: When an END_DOCUMENT event is encountered, the parsing is complete.
>     
> 4. **Applying the Default Workspace:**
>   - **applyDefaultWorkspaceItems():** After parsing, the applyDefaultWorkspaceItems() method is called.
>   - **Adding Items to Database: **The applyDefaultWorkspaceItems() method adds the parsed items to the launcher's database (LauncherProvider).
>   - ContentValues: ContentValues objects are used to store the data for each item before inserting it into the database.
>   - LauncherSettings.Favorites: The LauncherSettings.Favorites table is used to store the information about the items.
>   - ContentResolver.insert(): The ContentResolver.insert() method is used to insert the data into the database.
>   - bindWorkspace(): The bindWorkspace() method is called to bind the data to the UI.
>     
> 5. **Binding to the UI:**
>   - Workspace: The Workspace view is responsible for displaying the home screen.
>   - CellLayout: The Workspace uses CellLayout to arrange the items in a grid.
>   - addItem(): The Workspace's addItem() method is called to add each item to the UI.
>   - ShortcutAndWidgetContainer: The ShortcutAndWidgetContainer is used to hold the items.
>   - addViewToCellLayout(): The addViewToCellLayout() method is used to add the item to the CellLayout.
>     



> ```
> START
>   |
>   v
> [Launcher.onCreate()]  {Launcher Activity Starts}
>   |
>   v
> [Create LauncherModel]
>   |
>   v
> [LauncherModel.startLoader()]
>   |
>   v
> [LauncherModel.loadWorkspace()]
>   |
>   v
> [LauncherModel.loadDefaultFavorites()]
>   |
>   v
> [Create XmlResourceParser] {default_workspace.xml}
>   |
>   v
> [Get XmlPullParser]
>   |
>   v
> [Loop Through XmlPullParser Events]
>   |
>   v
> (Event Type?)
>   |
>   +-->(START_TAG)
>   |    |
>   |    v
>   |  (Tag Name?)
>   |    |
>   |    +-->(<favorites>) --> [Continue to Next Event]
>   |    |
>   |    +-->(<favorite>) --> [Extract Attributes (packageName, className, container, screen, x, y, etc.)]
>   |    |                  |
>   |    |                  v
>   |    |                  [Create ShortcutInfo]
>   |    |                  |
>   |    |                  v
>   |    |                  [Add ShortcutInfo to Item List]
>   |    |
>   |    +-->(<appwidget>) --> [Extract Attributes (packageName, className, spanX, spanY, etc.)]
>   |    |                  |
>   |    |                  v
>   |    |                  [Create AppWidgetProviderInfo]
>   |    |                  |
>   |    |                  v
>   |    |                  [Add AppWidgetProviderInfo to Item List]
>   |    |
>   |    +-->(<folder>) --> [Extract Attributes (title, etc.)]
>   |                       |
>   |                       v
>   |                       [Create FolderInfo]
>   |                       |
>   |                       v
>   |                       [Add FolderInfo to Item List]
>   |
>   +-->(END_TAG)
>   |    |
>   |    v
>   |  (Tag Name?)
>   |    |
>   |    +-->(<favorite> or <appwidget> or <folder>) --> [Continue to Next Event]
>   |
>   +-->(END_DOCUMENT)
>   |    |
>   |    v
>   |  [LauncherModel.applyDefaultWorkspaceItems()]
>   |    |
>   |    v
>   |  [Add Items to Database (LauncherProvider)] {LauncherSettings.Favorites}
>   |    |
>   |    v
>   |  [LauncherModel.bindWorkspace()]
>   |    |
>   |    v
>   |  [Workspace.addItem()]
>   |    |
>   |    v
>   |  [Add Item to CellLayout]
>   |    |
>   |    v
> END
> ```