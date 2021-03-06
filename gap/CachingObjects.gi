#############################################################################
##
##                                               ToolsForHomalg package
##
##  Copyright 2013 - 2014, Sebastian Gutsche, TU Kaiserslautern
##                         Sebastian Posur,   RWTH Aachen
##
##
#############################################################################

DeclareRepresentation( "IsCachingObjectRep",
                       IsAttributeStoringRep and IsCachingObject,
                       [ ] );

DeclareRepresentation( "IsWeakCachingObjectRep",
                       IsCachingObjectRep,
                       [ ] );

DeclareRepresentation( "IsCrispCachingObjectRep",
                       IsCachingObjectRep,
                       [ ] );

DeclareRepresentation( "IsMixedCachingObjectRep",
                       IsCachingObjectRep,
                       [ ] );

DeclareRepresentation( "IsCachingObjectWhichConvertsLists",
                       IsCachingObjectRep,
                       [ ] );

BindGlobal( "TheFamilyOfCachingObjects",
        NewFamily( "TheFamilyOfCachingObjects" ) );

BindGlobal( "TheTypeOfWeakCachingObject",
        NewType( TheFamilyOfCachingObjects,
                 IsWeakCachingObjectRep ) );

BindGlobal( "TheTypeOfCrispCachingObject",
        NewType( TheFamilyOfCachingObjects,
                 IsCrispCachingObjectRep ) );

##
InstallGlobalFunction( CATEGORIES_FOR_HOMALG_SET_ALL_CACHES_CRISP,
                       
  function( )
    
    InstallMethod( CachingObject,
                   [ IsBool, IsInt ],
                   
      function( is_crisp, nr_keys )
        
        return CreateCrispCachingObject( nr_keys );
        
    end );
    
end );

##
InstallGlobalFunction( CACHINGOBJECT_HIT,
                       
  function( cache )
    
    cache!.hit_counter := cache!.hit_counter + 1;
    
end );

##
InstallGlobalFunction( CACHINGOBJECT_MISS,
                       
  function( cache )
    
    cache!.miss_counter := cache!.miss_counter + 1;
    
end );

InstallGlobalFunction( COMPARE_LISTS_WITH_IDENTICAL,
                       
  function( list1, list2 )
    local i;
    
    if not IsList( list1 ) and not IsList( list2 ) then
        
        return IsIdenticalObj( list1, list2 );
        
    elif not IsList( list1 ) or not IsList( list2 ) then
        
        return false;
        
    fi;
    
    if Length( list1 ) <> Length( list2 ) then
        
        return false;
        
    fi;
    
    if IsString( list1 ) and IsString( list2 ) then
        
        return list1 = list2;
        
    fi;
    
    for i in [ 1 .. Length( list1 ) ] do
        
        if not IsBoundElmWPObj( list1, i ) or not IsBoundElmWPObj( list2, i ) then
            
            return false;
            
        elif not COMPARE_LISTS_WITH_IDENTICAL( ElmWPObj( list1, i ), ElmWPObj( list2, i ) ) then
            
            return false;
            
        fi;
        
    od;
    
    return true;
    
end );

## FIXME: Maybe do not search by IsIdenticalObj
InstallGlobalFunction( SEARCH_WPLIST_FOR_OBJECT,
                       
  function( wp_list, crisp_list, object )
    local pos;
    
    for pos in [ 1 .. LengthWPObj( wp_list ) ] do
        
        if IsBoundElmWPObj( wp_list, pos ) then
            
            if ElmWPObj( wp_list, pos ) = SuPeRfail and IsEqualForCache( object, crisp_list[ pos ] ) then ##Look at lists with =.
                
                return pos;
                
            elif IsEqualForCache( object, wp_list[ pos ] ) then
                
                return pos;
                
            fi;
            
        fi;
        
    od;
    
    return fail;
    
end );

InstallGlobalFunction( CATEGORIES_FOR_HOMALG_PREPARE_CACHING_RECORD,
                       
  function( nr_keys )
    local cache, i;
    
    cache := rec( keys := [ ],
                crisp_keys := [ ],
                nr_keys := nr_keys,
                keys_value_list := [ ],
                value_list_position := 1,
                hit_counter := 0,
                miss_counter := 0 );
    
    cache.keys := List( [ 1 .. nr_keys ], i -> WeakPointerObj( [ ] ) );
    
    cache.crisp_keys := List( [ 1 .. nr_keys ], i -> [ ] );
    
    return cache;
    
end );

InstallGlobalFunction( CreateWeakCachingObject,
                       
  function( nr_keys )
    local cache, i;
    
    cache := CATEGORIES_FOR_HOMALG_PREPARE_CACHING_RECORD( nr_keys );
    
    cache.value := WeakPointerObj( [ ] );
    
    ObjectifyWithAttributes( cache, TheTypeOfWeakCachingObject );
    
    return cache;
    
end );

InstallGlobalFunction( CreateCrispCachingObject,
                       
  function( nr_keys )
    local cache;
    
    cache := CATEGORIES_FOR_HOMALG_PREPARE_CACHING_RECORD( nr_keys );
    
    cache.value := [ ];
    
    ObjectifyWithAttributes( cache, TheTypeOfCrispCachingObject );
    
    return cache;
    
end );

InstallMethod( CachingObject,
               [ ],
               
  function( )
    
    return CreateWeakCachingObject( 1 );
    
end );

InstallMethod( CachingObject,
               [ IsBool ],
               
  function( is_crisp )
    
    return CachingObject( is_crisp, 1 );
    
end );

InstallMethod( CachingObject,
               [ IsBool, IsInt ],
               
  function( is_crisp, nr_keys )
    
    if is_crisp = true then
        
        return CreateCrispCachingObject( nr_keys );
        
    fi;
    
    return CreateWeakCachingObject( nr_keys );
    
end );

InstallMethod( CachingObject,
               [ IsInt, IsBool ],
               
  function( nr_keys, is_crisp )
    
    return CachingObject( is_crisp, nr_keys );
    
end );

InstallMethod( CachingObject,
               [ IsInt ],
               
  function( nr_keys )
    
    return CachingObject( false, nr_keys );
    
end );

InstallMethod( Add,
               [ IsWeakCachingObjectRep, IsInt, IsObject ],
               
  function( cache, pos, object )
    
    SetElmWPObj( cache!.value, pos, object );
    
end );

InstallMethod( Add,
               [ IsCrispCachingObjectRep, IsInt, IsObject ],
               
  function( cache, pos, object )
    
    cache!.value[ pos ] := object;
    
end );

InstallMethod( GetObject,
               [ IsWeakCachingObjectRep, IsInt, IsInt ],
               
  function( cache, pos, key_pos )
    local list;
    
    list := cache!.value;
    
    if IsBoundElmWPObj( list, pos ) then
        
        CACHINGOBJECT_HIT( cache );
        
        return ElmWPObj( list, pos );
        
    fi;
    
    CACHINGOBJECT_MISS( cache );
    
    Remove( cache!.keys_value_list, key_pos );
    
    Remove( cache!.value, pos );
    
    cache!.value_list_position := cache!.value_list_position - 1;
    
    return SuPeRfail;
    
end );

InstallMethod( GetObject,
               [ IsCrispCachingObjectRep, IsInt, IsInt ],
               
  function( cache, pos, key_pos )
    local list;
    
    list := cache!.value;
    
    if IsBound( list[ pos ] ) then
        
        CACHINGOBJECT_HIT( cache );
        
        return list[ pos ];
        
    fi;
    
    CACHINGOBJECT_MISS( cache );
    
    Remove( cache!.keys_value_list, key_pos );
    
    Remove( cache!.value, pos );
    
    cache!.value_list_position := cache!.value_list_position - 1;
    
    return SuPeRfail;
    
end );

InstallMethod( SetCacheValue,
               [ IsCachingObject, IsObject, IsObject ],
               
  function( cache, key, value )
    
    SetCacheValue( cache, [ key ], value );
    
end );

InstallMethod( SetCacheValue,
               [ IsCachingObject, IsList, IsObject ],
               
  function( cache, key_list, value )
    local keys, length_key_list, i, position, entry_position, entry_key, wp_list, crisp_keys;
    
    length_key_list := Length( key_list );
    
    if cache!.nr_keys <> length_key_list then
        
        Error( "cache supports only keys of length ", String( cache!.nr_keys ) );
        
    fi;
    
    keys := cache!.keys;
    
    entry_key := [ ];
    
    crisp_keys := cache!.crisp_keys;
    
    for i in [ 1 .. length_key_list ] do
        
        position := SEARCH_WPLIST_FOR_OBJECT( keys[ i ], crisp_keys[ i ], key_list[ i ] );
        
        if position = fail then
            
            ##Inject here.
            position := LengthWPObj( keys[ i ] ) + 1;
            
            if IsList( key_list[ i ] ) then
                
                if IsString( key_list[ i ] ) then
                    
                    crisp_keys[ i ][ position ] := key_list[ i ];
                    
                else
                    
                    crisp_keys[ i ][ position ] := WeakPointerObj( key_list[ i ] );
                    
                fi;
                
                SetElmWPObj( keys[ i ], position, SuPeRfail );
                
            else
                
                SetElmWPObj( keys[ i ], position, key_list[ i ] );
                
            fi;
            
        fi;
        
        entry_key[ i ] := position;
        
    od;
    
    entry_position := cache!.value_list_position;
    
    cache!.keys_value_list[ entry_position ] := entry_key;
    
    Add( cache, entry_position, value );
    
    cache!.value_list_position := entry_position + 1;
    
end );

InstallMethod( CacheValue,
               [ IsCachingObject, IsObject ],
               
  function( cache, key )
    
    return CacheValue( cache, [ key ] );
    
end );

##
InstallMethod( CacheValue,
               [ IsCachingObject, IsList ],
               
  function( cache, key_list )
    local length_key_list, keys, position, i, entry_key, crisp_keys;
    
    length_key_list := Length( key_list );
    
    if cache!.nr_keys <> length_key_list then
        
        Error( "cache supports only keys of length ", String( cache!.nr_keys ) );
        
    fi;
    
    keys := cache!.keys;
    
    crisp_keys := cache!.crisp_keys;
    
    entry_key := [ ];
    
    for i in [ 1 .. length_key_list ] do
        
        position := SEARCH_WPLIST_FOR_OBJECT( keys[ i ], crisp_keys[ i ], key_list[ i ] );
        
        if position = fail then
            
            CACHINGOBJECT_MISS( cache );
            
            return SuPeRfail;
            
        fi;
        
        entry_key[ i ] := position;
        
    od;
    
    position := Position( cache!.keys_value_list, entry_key );
    
    if position = fail then
        
        CACHINGOBJECT_MISS( cache );
        
        return SuPeRfail;
        
    fi;
    
    return GetObject( cache, position, position );
    
end );

##
InstallGlobalFunction( InstallMethodWithCrispCache,
                       
  function( arg )
    
    PushOptions( rec( CrispCache := true ) );
    
    CallFuncList( InstallMethodWithCache, arg );
    
end );

## InstallMethod( opr[, info][, famp], args-filts[, val], method )
##
InstallGlobalFunction( InstallMethodWithCache,
                       
  function( arg )
    local new_func, i, filt_list, crisp, arg_nr, cache, func, install_func, install_has_func, install_set_func;
    
    cache := ValueOption( "Cache" );
    
    ##find filter list
    for i in [ 2 .. 4 ] do
        
        if not IsString( arg[ i ] ) and not IsFunction( arg[ i ] ) then
            
            filt_list := arg[ i ];
            
            break;
            
        fi;
        
    od;
    
    if not IsBound( filt_list ) then
        
        Error( "something went wrong. This should not happen" );
        
    fi;
    
    crisp := ValueOption( "CrispCache" );
    
    if crisp = fail then
        
        crisp := false;
        
    fi;
    
    arg_nr := Length( filt_list );
    
    if cache = fail then
        
        cache := CachingObject( crisp, arg_nr );
        
    fi;
    
    func := arg[ Length( arg ) ];
    
    if cache <> false then
        
        new_func := function( arg )
          local value;
            
            value := CacheValue( cache, arg );
            
            if value <> SuPeRfail then
                
                return value;
                
            fi;
            
            value := CallFuncList( func, arg );
            
            SetCacheValue( cache, arg, value );
            
            return value;
            
        end;
        
    else
        
        new_func := func;
        
    fi;
    
    arg[ Length( arg ) ] := new_func;
    
    install_func := ValueOption( "InstallMethod" );
    
    if install_func = fail then
        
        install_func := InstallMethod;
        
    fi;
    
    CallFuncList( install_func, arg );
    
    install_has_func := ValueOption( "InstallHas" );
    
    if install_has_func = fail then
        
        install_has_func := InstallHas;
        
    fi;
    
    install_has_func( cache, NameFunction( arg[ 1 ] ), filt_list );
    
    install_set_func := ValueOption( "InstallSet" );
    
    if install_set_func = fail then
        
        install_set_func := InstallSet;
        
    fi;
    
    install_set_func( cache, NameFunction( arg[ 1 ] ), filt_list );
    
end );

##
InstallGlobalFunction( InstallMethodWithCacheFromObject,
                       
  function( arg )
    local new_func, func, i, filt_list, cache_object, install_name, install_func, install_has_func, install_set_func;
    
    install_name := NameFunction( arg[ 1 ] );
    
    cache_object := ValueOption( "ArgumentNumber" );
    
    if cache_object = fail then
        
        cache_object := 1;
        
    fi;
    
    func := arg[ Length( arg ) ];
    
    for i in [ 2 .. 4 ] do
        
        if not IsString( arg[ i ] ) and not IsFunction( arg[ i ] ) then
            
            filt_list := arg[ i ];
            
            break;
            
        fi;
        
    od;
    
    install_name := NameFunction( arg[ 1 ] );
    
    if cache_object <> false then
        
        new_func := function( arg )
          local value, cache;
            
            cache := CachingObject( arg[ cache_object ], install_name, Length( arg ) );
            
            value := CacheValue( cache, arg );
            
            if value <> SuPeRfail then
                
                return value;
                
            fi;
            
            value := CallFuncList( func, arg );
            
            SetCacheValue( cache, arg, value );
            
            return value;
            
        end;
        
    else
        
        new_func := func;
        
    fi;
    
    install_has_func := ValueOption( "InstallHas" );
    
    if install_has_func = fail then
        
        install_has_func := InstallHas;
        
    fi;
    
    install_has_func( cache_object, install_name, filt_list );
    
    install_set_func := ValueOption( "InstallSet" );
    
    if install_set_func = fail then
        
        install_set_func := InstallSet;
        
    fi;
    
    install_set_func( cache_object, install_name, filt_list );
    
    arg[ Length( arg ) ] := new_func;
    
    install_func := ValueOption( "InstallMethod" );
    
    if install_func = fail then
        
        install_func := InstallMethod;
        
    fi;
    
    CallFuncList( InstallMethod, arg );
    
end );

##
InstallMethod( InstallHas,
               [ IsCachingObject, IsString, IsList ],
               
  function( cache, name, filter )
    local has_name;
    
    has_name := Concatenation( "Has", name );
    
    if not IsBoundGlobal( has_name ) then
        
        DeclareOperation( has_name,
                          filter );
        
    fi;
    
    InstallOtherMethod( ValueGlobal( has_name ),
                        filter,
                        
      function( arg )
        local cache_return;
        
        cache_return := CacheValue( cache, arg );
        
        return cache_return <> SuPeRfail;
        
    end );
    
end );

##
InstallMethod( InstallSet,
               [ IsCachingObject, IsString, IsList ],
               
  function( cache, name, filter )
    local set_name, install_func;
    
    set_name := Concatenation( "Set", name );
    
    if not IsBoundGlobal( set_name ) then
        
        DeclareOperation( set_name,
                          Concatenation( filter, [ IsObject ] ) );
        
    fi;
    
    install_func := ValueOption( "InstallMethod" );
    
    if install_func = fail then
        
        install_func := InstallOtherMethod;
        
    fi;
    
    install_func( ValueGlobal( set_name ),
                  Concatenation( filter, [ IsObject ] ),
                        
      function( arg )
        local cache_return, cache_call;
        
        cache_call := arg{[ 1 .. Length( filter ) - 1 ]};
        
        cache_return := CacheValue( cache, cache_call );
        
        if cache_return = SuPeRfail then
            
            CallFuncList( SetCacheValue, [ cache, cache_call, arg[ Length( arg ) ] ] );
            
        fi;
        
    end : InstallMethod := InstallOtherMethod );
    
end );

##
InstallMethod( InstallHas,
               [ IsInt, IsString, IsList ],
               
  function( cache_number, name, filter )
    local has_name;
    
    has_name := Concatenation( "Has", name );
    
    if not IsBoundGlobal( has_name ) then
        
        DeclareOperation( has_name,
                          filter );
        
    fi;
    
    InstallOtherMethod( ValueGlobal( has_name ),
                        filter,
                        
      function( arg )
        local cache, cache_return;
        
        cache := CachingObject( arg[ cache_number ], name, Length( filter ) );
        
        cache_return := CacheValue( cache, arg );
        
        return cache_return <> SuPeRfail;
        
    end );
    
end );

##
InstallMethod( InstallSet,
               [ IsInt, IsString, IsList ],
               
  function( cache_number, name, filter )
    local set_name, install_func;
    
    set_name := Concatenation( "Set", name );
    
    if not IsBoundGlobal( set_name ) then
        
        DeclareOperation( set_name,
                          Concatenation( filter, [ IsObject ] ) );
        
    fi;
    
    install_func := ValueOption( "InstallMethod" );
    
    if install_func = fail then
        
        install_func := InstallOtherMethod;
        
    fi;
    
    install_func( ValueGlobal( set_name ),
                  Concatenation( filter, [ IsObject ] ),
                        
      function( arg )
        local cache, cache_key, cache_return;
        
        cache := CachingObject( arg[ cache_number ], name, Length( arg ) - 1 );
        
        cache_key := arg{[ 1 .. Length( arg ) - 1 ]};
        
        cache_return := CacheValue( cache, cache_key );
        
        if cache_return = SuPeRfail then
            
            CallFuncList( SetCacheValue, [ cache, cache_key, arg[ Length( arg ) ] ] );
            
        fi;
        
    end : InstallMethod := InstallOtherMethod );
    
end );

##
InstallMethod( InstallHas,
               [ IsBool, IsString, IsList ],
               
  function( cache, name, filter )
    local has_name;
    
    has_name := Concatenation( "Has", name );
    
    if not IsBoundGlobal( has_name ) then
        
        DeclareOperation( has_name,
                          filter );
        
    fi;
    
    InstallOtherMethod( ValueGlobal( has_name ),
                        filter,
                        
      ReturnFalse );
    
end );

##
InstallMethod( InstallSet,
               [ IsBool, IsString, IsList ],
               
  function( cache, name, filter )
    local has_name, set_name;
    
    set_name := Concatenation( "Set", name );
    
    if not IsBoundGlobal( set_name ) then
        
        DeclareOperation( set_name,
                          Concatenation( filter, [ IsObject ] ) );
        
    fi;
    
    InstallOtherMethod( ValueGlobal( set_name ),
                        Concatenation( filter, [ IsObject ] ),
                        
      function( arg )
        
        return;
        
    end );
    
end );

##
InstallMethod( DeclareHasAndSet,
               [ IsString, IsList ],
               
  function( name, filter )
    local has_name, set_name;
    
    has_name := Concatenation( "Has", name );
    
    set_name := Concatenation( "Set", name );
    
    DeclareOperation( has_name, filter );
    
    Add( filter, IsObject );
    
    DeclareOperation( set_name, filter );
    
end );

##
InstallMethod( DeclareOperationWithCache,
               [ IsString, IsList ],
               
  function( name, filter )
    local has_name, set_name;
    
    DeclareOperation( name, filter );
    
    DeclareHasAndSet( name, filter );
    
end );

##
InstallMethod( IsEqualForCache,
               [ IsObject, IsObject ],
               
  IsIdenticalObj );



##
InstallMethod( IsEqualForCache,
               [ IsList, IsList ],
               
  function( list1, list2 )
    local length;
    
    length := Length( list1 );
    
    if Length( list2 ) <> length then
        
        return false;
        
    fi;
    
    return ForAll( [ 1 .. length ], i -> IsEqualForCache( list1[ i ], list2[ i ] ) );
    
end );

##
InstallMethod( IsEqualForCache,
               [ IsString, IsString ],
               
  \= );
