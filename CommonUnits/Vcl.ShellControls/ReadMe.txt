To compile TripManager you need to install the ShellCtrls, using a slightly modified version of the Embarcadero Shell Controls.
Due to the Copyright statement I can't distribute that source, but the Community Edition comes with the source code of these controls.

- Find the files Vcl.Shell.ShellConsts.pas and Vcl.Shell.ShellCtrls.pas in the Embarcadero Source directory and copy them to this directory.

- Modify the Vcl.Shell.ShellCtrls.pas file.

1) In the 'public' declarations of TShellTreeView, add

property OnCustomDrawItem;

2) In the 'private' declarations of TCustomShellListView, comment 'procedure EnumColumns'.

//  procedure EnumColumns;

3) In the 'protected' declarations of TCustomShellListView, add 'procedure EnumColumns' decorated with 'virtual'.

    procedure EnumColumns; virtual;

4) In the 'public' declarations of TCustomShellListView, add:

    property FoldersList: TList read FFolders;

- Open the ShellControls.groupproj in Delphi (Or CBuilder), Compile and Install the 32 Bits version. The 64 Bits also works, but is not needed.

Notes:

- If you already have these controls installed, make the modifications described above to your version.
- The subdirectory 'Vcl.ShellControls' is in the Search path of the Project. 

