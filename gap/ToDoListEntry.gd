#############################################################################
##
##  ToDoListEntry.gd                                 ToolsForHomalg package
##
##  Copyright 2007-2012, Mohamed Barakat, University of Kaiserslautern
##                       Sebastian Gutsche, RWTH-Aachen University
##                  Markus Lange-Hegermann, RWTH-Aachen University
##
##  Entries for ToDo-Lists.
##
#############################################################################

DeclareCategory( "IsToDoListEntry",
                 IsObject );

DeclareGlobalVariable( "TODO_LIST_ENTRIES" );

##################################
##
## Methods and properties
##
##################################

DeclareFilter( "IsDone", IsToDoListEntry );

DeclareFilter( "PreconditionsDefinitelyNotFulfilled", IsToDoListEntry );

DeclareOperationWithDocumentation( "SourcePart",
                                   [ IsToDoListEntry ],
                                   [ "Returns the a list of source parts of the ToDo-list entry <A>entry</A>.",
                                     "This is a triple of an object, a name of a filter/attribute, and a value to which",
                                     "the attribute has to be set to activate the entry" ],
                                   "a list",
                                   "entry",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "TargetPart",
                                  [ IsToDoListEntry ],
                                  [ "Returns the target part of the ToDo-list entry <A>entry</A>.",
                                    "This is a triple of an object, a name of a filter/attribute, and a value to which the",
                                    "specific filter/attribute should be set.",
                                    "The third entry of the list might also be a function to which return value the",
                                    "attribute is set." ],
                                  "a list",
                                  "entry",
                                  [ "ToDo-list", "ToDo-list_entries" ]
                                );

DeclareOperationWithDocumentation( "SetTargetValueObject",
                                   [ IsToDoListEntry, IsObject ],
                                   [ "If the given value of the target part is the return value of a function",
                                     "this command sets the target value of the entry to a function.",
                                     "This is done to keep proof tracking availible." ],
                                   "nothing",
                                   "entry,value",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                );

DeclareOperationWithDocumentation( "SetTargetObject",
                                   [ IsToDoListEntry, IsObject ],
                                   [ "If the target object, i.e. the first entry of the target part, was given as",
                                     "a function, this method can set this entry to the return value computed in",
                                     "ProcessToDoListEntry. This happens atomatically, do not worry about it." ],
                                   "nothing",
                                   "entry,obj",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                );

DeclareOperationWithDocumentation( "ProcessAToDoListEntry",
                                   [ IsToDoListEntry ],
                                   [ "Processes a ToDo-list entry, i.e. sets the information given in TargetPart",
                                     "if the definitions in SourcePart are fulfilled.",
                                     "Returns true if the entry could be processed, false if not, and fail if",
                                     "SourcePart or TargetPart weren't availible anymore." ],
                                   "a boolean",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "AreCompatible",
                                   [ IsToDoListEntry, IsToDoListEntry ],
                                   [ "Returns true if TargetPart( <A>A</A> ) = SourcePart( <A>B</A> ),",
                                     "false otherwise." ],
                                   "a boolean",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "ToDoListEntryWithWeakPointers",
                                   [ IsObject, IsString, IsObject, IsObject, IsString, IsObject ],
                                   [ "Creates a ToDo-list entry where the first three arguments",
                                     "correspond to the SourcePart of the entry and the last three",
                                     "ones to the TargetPart.",
                                     "This type of entry uses weakpointers as links to the object",
                                     "so you might be careful with it." ],
                                   "a ToDoListEntry",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "ToDoListEntryWithPointers",
                                   [ IsObject, IsString, IsObject, IsObject, IsString, IsObject ],
                                   [ "The same as ToDoListEntryWithWeakPointers, but with pointers." ],
                                   "a ToDoListEntry",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "ToDoListEntryWithListOfSources",
                                   [ IsList, IsObject, IsString, IsObject ],
                                   [ "The same as ToDoListEntryWithPointers, but the first argument",
                                     "must be a list of touples or triples defining the conditions of this entry" ],
                                   "a ToDoListEntry",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "ToDoListEntryWhichLaunchesAFunction",
                                   [ IsList, IsFunction ],
                                   [ "The first argument must be a list of tuples or triples which contain",
                                     "an object, on which the second entry, an attribute given by its name as a string",
                                     "can be applied. It the entry is a tuple",
                                     "the ToDo-list entry checks wether the Tester of the",
                                     "second value is true.",
                                     "If the value of the attribute matches the third entry,",
                                     "the function given as second argument is launched." ],
                                   "a ToDoListEntry",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                  );

DeclareOperationWithDocumentation( "ToDoListEntryWithContraposition",
                                    [ IsObject, IsString, IsBool, IsObject, IsString, IsBool ],
                                    [ "Creates a ToDoListEntry which also installs a contraposition.",
                                      "The arguments <A>source_prop</A> and <A>target_prop</A> need to be",
                                      "strings that name a property, and <A>sval</A> and <A>tval</A> need to be",
                                      "boolean values, i.e. true or false." ],
                                    "a ToDoListEntry",
                                    "sobj,source_prop,sval,tobj,target_prop,tval",
                                    [ "ToDo-list", "ToDo-list_entries" ]
                );

DeclareOperationWithDocumentation( "ToDoListEntryForEquivalentProperties",
                                   [ IsObject, IsString, IsObject, IsString ],
                                   [ "Creates a ToDoListEntry for two equivalent",
                                     "properties, which means that both values of the two properties",
                                     "will be propagated in both directions." ],
                                   "a ToDoListEntry",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "CreateImmediateMethodForToDoListEntry",
                                   [ IsToDoListEntry ],
                                   [ "Creates an ImmediateMethod for a ToDoListEntry.",
                                     "This method is for internal use only." ],
                                   "nothing",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareOperationWithDocumentation( "JoinToDoListEntries",
                                   [ IsList ],
                                   [ "Joins a list of compatible ToDo-list entries to a new one." ],
                                   "a ToDoListEntry",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareAttributeWithDocumentation( "GenesisOfToDoListEntry",
                                   IsToDoListEntry,
                                   [ "If a ToDoListEntry is created as union of others, this is a list of those." ],
                                   "a list",
                                   [ "ToDo-list", "ToDo-list_entries" ]
                                 );

DeclareAttributeWithDocumentation( "DescriptionOfImplication",
                                   IsToDoListEntry,
                                   [ "Has to be set to a string, which describes the reason for the conclusion.",
                                     "If the ToDo-list entry is displayed, the given string will be displayed with a",
                                     "because before it." ],
                                     "a list",
                                     [ "ToDo-list", "ToDo-list_entries" ]
                                  );

DeclareGlobalFunction( "ToDoLists_Process_Entry_Part" );

DeclareGlobalFunction( "ToolsForHomalg_MoveAToDoListEntry" );

DeclareGlobalFunction( "ToolsForHomalg_ProcessToDoListEquivalenciesAndContrapositions" );