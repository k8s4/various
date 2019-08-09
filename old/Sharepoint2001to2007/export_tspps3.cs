using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using Microsoft.SharePoint;
using Microsoft.SharePoint.WebControls;

class MainClass
{
	public static void Main(string[] args) {

/*
		String DiskPath = "d:\Migration"; 		// Путь до рабочей папки, с документами
		String FoldersList = diskpath + "folders.txt";	// Путь до файла со списком папок
		String FilesList = diskpath + "files.txt";	// Путь до файла со списком файлов
		String currentdiskfile;				// Текущий файл

		String SPSSserver = "http://mcwspp02";		// URL сервера SharePoint
		String DocLibrary = "Shared Documents";		// Имя библиотеки документов
		String currentspsfile;				// Текущий файл
	
		Int counterfiles;				// Инкремент обработанных файлов
		Int counterfolders;				// Инкремент обработанных папок
		Int countersize;				// Размер загруженных файлов

		CreateCustomField(SPSServer, DocLibrary, "Author");
		CreateCustomField(SPSServer, DocLibrary, "Description");
		CreateCustomField(SPSServer, DocLibrary, "Keywords");

		string path = @"c:\docs.doc";
		string sharePointURL = "http://mcwspp02/";
		string LibraryName = "Shared Documents";
		string file = "docs.doc";
*/
		string SPSServer 	= "http://sharepoint2007.domain.local";		// URL сервера SharePoint
		string DocLibrary 	= "TestLibs";			// Имя библиотеки документов
		string LocalDir		= "J:\\Migration";
		string FoldersList 	= LocalDir + "\\folders.txt";		// Путь до файла со списком папок
		string FilesList 	= LocalDir + "\\files.txt";		// Путь до файла со списком папок
		string logFile 		= "C:\\logs.txt";
/*
		MigrationWSS.WriteLog("Start creating folders structure.", logFile );
		MigrationWSS.CreateFolderTree(SPSServer, DocLibrary, FoldersList);
		MigrationWSS.WriteLog("Stop creating folders structure.", logFile );
*/
		MigrationWSS.WriteLog("Start copy files.", logFile );
		MigrationWSS.CopyFiles( SPSServer, DocLibrary, FilesList, LocalDir);
		MigrationWSS.WriteLog("Stop copy files.", logFile );
	}

	public class MigrationWSS {
		public static void CreateFolderTree(string spsURL, string libName, string fileFolders) {
		  using (SPSite site = new SPSite( spsURL )) {
		    using (SPWeb web = site.OpenWeb()) {
		      string fullpath 		= spsURL + "/" + libName;
		      char charReplace 		= '_';
		      char[] sch_or 		= { '|' };
		      char[] sch_star 	= { '*' };
		      char[] sch_slash 	= { '\\' };
		      string logFile 		= "c:\\logs.txt";
		      string limitGroup 	= "TestGroup";

		      using (System.IO.StreamReader sr = new System.IO.StreamReader( fileFolders )) {
			while (!sr.EndOfStream) {
				string s = sr.ReadLine();
				string forPath = fullpath;
				string[] sarr 		= s.Split( sch_or );
				sarr[0] = StringClean(sarr[0], charReplace);
		                string[] FPath 		= sarr[0].Split(sch_slash);
				string[] FCoordinators 	= sarr[1].Split( sch_star );
				string[] FAuthors 	= sarr[2].Split( sch_star );
				string[] FReaders 	= sarr[3].Split( sch_star );
				string[] FApprovers 	= sarr[4].Split( sch_star );
				int cols = FPath.GetLength( FPath.Rank - 1 );
				for (int i = 1; i < cols; i++) {
					SPFolder exFolder = web.GetFolder( forPath + "/" + FPath[i] );
					if (!exFolder.Exists) {
						SPFolderCollection colFolders = web.GetFolder( forPath ).SubFolders;
						colFolders.Add( FPath[i] );

						if (!exFolder.Exists) {
							WriteLog("===> Warning!!! Folder not create: " + forPath + "/" + FPath[i], logFile);
						}
					}
					if ( i == cols - 1 ) {	
						foreach (string coord in FCoordinators) {
							// spsURL, libName, Path, User, Permission
			                        	if (coord != "") {
							   string[] scoord = coord.Split(sch_slash);
							   if (scoord[0] == "EMEA") {
								AddToGroup( spsURL, limitGroup, coord);
								SetPermUser( spsURL, libName, forPath + "/" + FPath[i], coord, "Full Control");
							   }
							}
						}
						foreach (string author in FAuthors) {
			                        	if (author != "") {
							   string[] sauthor = author.Split(sch_slash);
							   if (sauthor[0] == "EMEA") {
								AddToGroup( spsURL, limitGroup, author);
								SetPermUser( spsURL, libName, forPath + "/" + FPath[i], author, "Contribute");
							   }
							}
						}
						foreach (string reader in FReaders) {
			                        	if (reader != "") {
							   string[] sreader = reader.Split(sch_slash);
							   if (sreader[0] == "EMEA") {
								AddToGroup( spsURL, limitGroup, reader);
								SetPermUser( spsURL, libName, forPath + "/" + FPath[i], reader, "Read");
							   }
							}
						}
						foreach (string approver in FApprovers) {
			                        	if (approver != "") {
							   string[] sapprover = approver.Split(sch_slash);
							   if (sapprover[0] == "EMEA") {
								AddToGroup( spsURL, limitGroup, approver);
								SetPermUser( spsURL, libName, forPath + "/" + FPath[i], approver, "Design");
							   }
							}
						}

					} 
					forPath += "/" + FPath[i];
				}
				forPath = "";
			}
		      }
		    }
		  }
		} // Close CreateFolderTree

		public static void CopyFiles( string spsURL, string libName, string fileFiles, string fromPath) {
		  using (SPSite site = new SPSite( spsURL )) {
		    using (SPWeb web = site.OpenWeb()) {
		      string fullPath 		= spsURL + "/" + libName;
		      char charReplace 		= '_';
		      char[] sch_or 		= { '|' };
		      char[] sch_star 	= { '*' };
		      char[] sch_slash 	= { '\\' };
		      using (System.IO.StreamReader sr = new System.IO.StreamReader( fileFiles )) {
			while (!sr.EndOfStream) {
				string s = sr.ReadLine();
				string[] sarr 		= s.Split( sch_or );
				string srcPath = fromPath + sarr[0];
				string verPath = fromPath + sarr[0] + ".cmt";
				string dstPath = fullPath + StringClean(sarr[0], charReplace);
				dstPath = dstPath.Replace("\\", "/");

				// Prepare dst path
				FileInfo fi = new FileInfo( srcPath );
				string dstVerFolder = dstPath.Replace("/" + StringClean(fi.Name, charReplace), "");
				string dstVerFile = StringClean(fi.Name, charReplace);

				Console.WriteLine("CopyVer: " + dstVerFolder + "; File: " + fi.Name);
				if (File.Exists(verPath)) {
					using (System.IO.StreamReader verFile = new System.IO.StreamReader( verPath, System.Text.Encoding.GetEncoding(1251))) {
						while (!verFile.EndOfStream) {
							string vs = verFile.ReadLine();
							if ( vs != "" ) {
								string[] vsarr = vs.Split( sch_or );
								string verSrcPath = fromPath + StringClean(vsarr[0], charReplace);
								string flagPub = vsarr[1];
								string ComM = vsarr[2];
								Console.WriteLine(vsarr[0] +" / "+ vsarr[1] + " / " + vsarr[2]);
								UploadFile( spsURL, verSrcPath, dstVerFolder, dstVerFile, ComM, flagPub);
							}
						} // End while read stream
					} // End Stream
				} // End If verPath
				UploadFile( spsURL, srcPath, dstVerFolder, dstVerFile, " ", "0");
				SPFile oDstFile = web.GetFile( dstPath );
				SPListItem it = oDstFile.Item;
				string Title = sarr[1];
				string Author = sarr[2];
				string Description = sarr[3];
				string Keywords = sarr[5].Replace("*", ", ");

				it["Title"] = Title;
				it["mAuthor"] = Author;
				it["mDescription"] = Description;
				it["mKeywords"] = Keywords;
				it.Update();
				oDstFile.CheckIn("Last Magration File");
			}
		      }
		    } 
		  }  
		}






// ----------------------------------------------------------------------------------------------------------
// Works methods

		public static void CreateCustomField( string spsURL, string libName, string fieldName )
		{
			SPWeb website = new SPSite( spsURL ).OpenWeb(); 
			SPFieldCollection collFields = website.Lists[ libName ].Fields;
			collFields.Add( fieldName, SPFieldType.Text, true );
		}
		public static void DeleteCustomField( string spsURL, string libName, string fieldName )
		{
			SPWeb website = new SPSite( spsURL ).OpenWeb(); 
			SPFieldCollection collFields = website.Lists[ libName ].Fields;
			collFields.Delete( collFields[ fieldName ].InternalName );
		}
		public static void WriteLog(string wrText, string flName) {
			TextWriter otw = new StreamWriter( flName, true );
			otw.WriteLine(DateTime.Now + "; " + wrText);
			otw.Close();
		}
		public static string StringClean(string input, char replace) {	
			string result = "";
			string tempchar = "";
			bool charflag = false;
			char[] rpChars = input.ToCharArray();
			char[] srChars = new char[] { '№', '~', '\"', '#', '%', '&', ':', '<', '>', '{', '|', '}', '$', '^', '@', '*', '?', '\''};
			foreach(char rpChar in rpChars) {
				foreach(char srChar in srChars) {
					if (rpChar == srChar) {
						charflag = true;	
					} 
				}
				tempchar = rpChar.ToString();
				if (charflag) {
					result += replace.ToString();
				} else {
					result += tempchar;
				}
				charflag = false;	
			}
			return result;
		}
		public static void SetPermGroup( string spsURL, string libName, string fPath, string grpName, string lvlAccess ) {
		// lvlAccess - Full Control; Design; Contribute; Read; View Only; Limited Access;
		  using (SPSite site = new SPSite( spsURL )) {
		    using (SPWeb web = site.OpenWeb()) {
                        SPFolder eXfolder = web.GetFolder( spsURL + "/" + libName + "/" + fPath );
			SPGroupCollection spc = web.SiteGroups;
			SPGroup group = spc[grpName];
			SPRoleAssignment roleAssignment = new SPRoleAssignment( (SPPrincipal)group );
			eXfolder.Item.BreakRoleInheritance(true);
			roleAssignment.RoleDefinitionBindings.Add( web.RoleDefinitions[lvlAccess] );
			eXfolder.Item.RoleAssignments.Add(roleAssignment);
		    }
		  }
		}
		public static void SetPermUser( string spsURL, string libName, string fPath, string usrName, string lvlAccess ) {
		// lvlAccess - Full Control; Design; Contribute; Read; View Only; Limited Access;
		  using (SPSite site = new SPSite( spsURL )) {
		    using (SPWeb web = site.OpenWeb()) {
                        SPFolder eXfolder = web.GetFolder( fPath );
			SPUserCollection spc = web.SiteUsers;
			SPUser username = spc[usrName];
			SPRoleAssignment roleAssignment = new SPRoleAssignment( (SPPrincipal)username );
			eXfolder.Item.BreakRoleInheritance(true);
			roleAssignment.RoleDefinitionBindings.Add( web.RoleDefinitions[lvlAccess] );
			eXfolder.Item.RoleAssignments.Add(roleAssignment);
		    }
		  }
		}
		public static void AddToGroup( string spsURL, string grpName, string userName)
		{
			SPSite site = new SPSite( spsURL ); 
			SPWeb web = site.OpenWeb(); 
			web.Groups[grpName].AddUser( userName, null, null, null);
		}
		public static void UploadFile( string spsURL, string srcFile, string dstFolder, string dstFile, string comments, string pubFlag) {
		  using (SPSite site = new SPSite( spsURL )) {
		    using (SPWeb web = site.OpenWeb()) {
			if (File.Exists( srcFile )) {
				// Check dst file exist and checkOut status
				SPFile oDstFile = web.GetFile( dstFolder + "/" + dstFile );
				Console.WriteLine("Get file: " + srcFile);
				if (oDstFile.Exists) {
					if (oDstFile.CheckOutStatus.ToString() == "None") {				
						oDstFile.CheckOut();
					}
				}
				// Read data from file to variable
				Stream fs = File.Open( srcFile, FileMode.Open, FileAccess.Read );
				byte[] var_data = new byte[fs.Length];
				fs.Read( var_data, 0, var_data.Length );
//				oDstFile.CheckOut();
				// Write data to MOSS 2007
				SPFolder folder = web.GetFolder( dstFolder );  
				SPFileCollection files = folder.Files;  
				files.Add( dstFile, var_data, true );
				if ( pubFlag == "2") {
					oDstFile.CheckIn("");
					oDstFile.Publish( comments );
				} else if ( pubFlag == "1" ) {				
					oDstFile.CheckIn( comments );
				} else if ( pubFlag == "0" ) {	

				}
			} else {
				Console.WriteLine("File not copy: " + srcFile);
				// ERRRRRRRRRRRRROOOOOOOOOOOOOOOOOORRRRRRRRRRR
			} // End if srcFile Exist
		    } // SPWeb close
		  } // SPSite close
		} // Method UploadFile close

	} // Close MigrationWSS Class
} // Close MainClass
