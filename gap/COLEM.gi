#############################################################################
##
##  COLEM.gi                    COLEM subpackage             Mohamed Barakat
##
##         COLEM = Clever Operations for Lazy Evaluated Matrices
##
##  Copyright 2007-2008 Lehrstuhl B f�r Mathematik, RWTH Aachen
##
##  Implementation stuff for the COLEM subpackage.
##
#############################################################################

####################################
#
# global variables:
#
####################################

# a central place for configuration variables:

InstallValue( COLEM,
        rec(
            color := "\033[4;30;46m" ) );

####################################
#
# logical implications methods:
#
####################################

##
InstallImmediateMethod( IsEmptyMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsEmptyMatrix( PreEval( M ) ) then
        return IsEmptyMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsZeroMatrix( PreEval( M ) ) then
        return IsZeroMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalInvolution( M ) ) then
        return IsZeroMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalLeftInverse, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalLeftInverse( M ) ) then
        return IsZeroMatrix( EvalLeftInverse( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalRightInverse, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalRightInverse( M ) ) then
        return IsZeroMatrix( EvalRightInverse( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalInverse, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalInverse( M ) ) then
        return IsZeroMatrix( EvalInverse( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalCertainRows, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalCertainRows( M )[1] ) and IsZeroMatrix( EvalCertainRows( M )[1] ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalCertainColumns, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalCertainColumns( M )[1] ) and IsZeroMatrix( EvalCertainColumns( M )[1] ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalUnionOfRows, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalUnionOfRows( M )[1] ) and IsZeroMatrix( EvalUnionOfRows( M )[1] )
       and HasIsZeroMatrix( EvalUnionOfRows( M )[2] ) and IsZeroMatrix( EvalUnionOfRows( M )[2] ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasEvalUnionOfColumns, 0,
        
  function( M )
    
    if HasIsZeroMatrix( EvalUnionOfColumns( M )[1] ) and IsZeroMatrix( EvalUnionOfColumns( M )[1] )
       and HasIsZeroMatrix( EvalUnionOfColumns( M )[2] ) and IsZeroMatrix( EvalUnionOfColumns( M )[2] ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsZeroMatrix,
        IsHomalgMatrix and HasPositionOfFirstNonZeroEntryPerRow, 0,
        
  function( M )
    local pos;
    
    pos := PositionOfFirstNonZeroEntryPerRow( M );
    
    return Set( pos ) in [ [ ], [ 0 ] ];
    
end );

##
InstallImmediateMethod( IsIdentityMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsIdentityMatrix( PreEval( M ) ) then
        return IsIdentityMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsIdentityMatrix,
        IsHomalgMatrix and IsPermutationMatrix and HasPositionOfFirstNonZeroEntryPerRow and HasNrRows, 0,
        
  function( M )
    
    return PositionOfFirstNonZeroEntryPerRow( M ) = [ 1 .. NrRows( M ) ];
    
end );

##
InstallImmediateMethod( IsPermutationMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsPermutationMatrix( PreEval( M ) ) then
        return IsPermutationMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsSubidentityMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsSubidentityMatrix( PreEval( M ) ) then
        return IsSubidentityMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsSubidentityMatrix,
        IsHomalgMatrix and HasEvalCertainRows, 0,
        
  function( M )
    local mat, plist, pos, pos_non_zero;
    
    mat := EvalCertainRows( M )[1];
    plist := EvalCertainRows( M )[2];
    
    if HasIsSubidentityMatrix( mat ) and IsSubidentityMatrix( mat ) then
        
        if HasNrRows( mat ) and HasNrColumns( mat )
           and NrRows( mat ) <= NrColumns( mat ) then
            
            return IsDuplicateFree( plist );
            
        fi;
        
        if HasPositionOfFirstNonZeroEntryPerRow( mat ) and HasNrColumns( mat ) then
            
            pos := PositionOfFirstNonZeroEntryPerRow( mat );
            
            pos := pos{ plist };
            
            pos_non_zero := Filtered( pos, i -> i <> 0 );
            
            if not IsDuplicateFree( pos_non_zero ) then
                return false;
            fi;
            
            if not 0 in pos					## NrRows( M ) <= NrColumns( M )
               or  Length( pos_non_zero ) = NrColumns( mat )	## NrColumns( M ) <= NrRows( M )
               then
                return true;
            fi;
            
        fi;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsSubidentityMatrix,
        IsHomalgMatrix and HasEvalCertainColumns, 0,
        
  function( M )
    local mat, plist, pos, plist_non_zero;
    
    mat := EvalCertainColumns( M )[1];
    plist := EvalCertainColumns( M )[2];
    
    if HasIsSubidentityMatrix( mat ) and IsSubidentityMatrix( mat ) then
        
        if HasNrColumns( mat ) and HasNrRows( mat )
           and NrColumns( mat ) <= NrRows( mat ) then
            
            return IsDuplicateFree( plist );
            
        fi;
        
        
        if HasPositionOfFirstNonZeroEntryPerRow( mat ) and HasNrRows( mat ) then
            
            pos := PositionOfFirstNonZeroEntryPerRow( mat );
            
            plist := List( plist, function( i ) if i in pos then return i; else return 0; fi; end );
            
            plist_non_zero := Filtered( plist, i -> i <> 0 );
            
            if not IsDuplicateFree( plist_non_zero ) then
                return false;
            fi;
            
            if not 0 in plist 					## NrColumns( M ) <= NrRows( M )
               or Length( plist_non_zero ) = NrRows( mat )	## NrRows( M ) <= NrColumns( M )
               then
                return true;
            fi;
            
        fi;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsRightInvertibleMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsRightInvertibleMatrix( PreEval( M ) ) then
        return IsRightInvertibleMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsRightInvertibleMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasIsLeftInvertibleMatrix( EvalInvolution( M ) ) then
        return IsLeftInvertibleMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsLeftInvertibleMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsLeftInvertibleMatrix( PreEval( M ) ) then
        return IsLeftInvertibleMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsLeftInvertibleMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasIsRightInvertibleMatrix( EvalInvolution( M ) ) then
        return IsRightInvertibleMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsFullRowRankMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsFullRowRankMatrix( PreEval( M ) ) then
        return IsFullRowRankMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsFullRowRankMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasIsFullColumnRankMatrix( EvalInvolution( M ) ) then
        return IsFullColumnRankMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsFullColumnRankMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsFullColumnRankMatrix( PreEval( M ) ) then
        return IsFullColumnRankMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsFullColumnRankMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasIsFullRowRankMatrix( EvalInvolution( M ) ) then
        return IsFullRowRankMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsUpperTriangularMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasIsLowerTriangularMatrix( EvalInvolution( M ) ) then
        return IsLowerTriangularMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsUpperTriangularMatrix,
        IsHomalgMatrix and HasEvalCertainRows, 0,
        
  function( M )
    local C;
    
    C := EvalCertainRows( M );
    
    if HasIsUpperTriangularMatrix( C[1] ) and IsUpperTriangularMatrix( C[1] )
       and ( C[2] = NrRows( C[1] ) + [ - Length( C[2] ) .. 0 ]
             or C[2] = [ 1 .. Length( C[2] ) ] ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsUpperTriangularMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsUpperTriangularMatrix( PreEval( M ) ) then
        return IsUpperTriangularMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsLowerTriangularMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasIsUpperTriangularMatrix( EvalInvolution( M ) ) then
        return IsUpperTriangularMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsLowerTriangularMatrix,
        IsHomalgMatrix and HasEvalCertainColumns, 0,
        
  function( M )
    local C;
    
    C := EvalCertainColumns( M );
    
    if HasIsLowerTriangularMatrix( C[1] ) and IsLowerTriangularMatrix( C[1] )
       and ( C[2] = NrColumns( C[1] ) + [ - Length( C[2] ) .. 0 ]
             or C[2] = [ 1 .. Length( C[2] ) ] ) then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsLowerTriangularMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsLowerTriangularMatrix( PreEval( M ) ) then
        return IsLowerTriangularMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsDiagonalMatrix,
        IsHomalgMatrix and HasEvalCertainRows, 0,
        
  function( M )
    local C;
    
    C := EvalCertainRows( M );
    
    if HasIsDiagonalMatrix( C[1] ) and IsDiagonalMatrix( C[1] )
       and C[2] = [ 1 .. Length( C[2] ) ] then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsDiagonalMatrix,
        IsHomalgMatrix and HasEvalCertainColumns, 0,
        
  function( M )
    local C;
    
    C := EvalCertainColumns( M );
    
    if HasIsDiagonalMatrix( C[1] ) and IsDiagonalMatrix( C[1] )
       and C[2] = [ 1 .. Length( C[2] ) ] then
        return true;
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsDiagonalMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsDiagonalMatrix( PreEval( M ) ) then
        return IsDiagonalMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsStrictUpperTriangularMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsStrictUpperTriangularMatrix( PreEval( M ) ) then
        return IsStrictUpperTriangularMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( IsStrictLowerTriangularMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasIsStrictLowerTriangularMatrix( PreEval( M ) ) then
        return IsStrictLowerTriangularMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

####################################
#
# immediate methods for attributes:
#
####################################

##
InstallImmediateMethod( NrRows,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasNrRows( PreEval( M ) ) then
        return NrRows( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( NrColumns,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasNrColumns( PreEval( M ) ) then
        return NrColumns( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( RowRankOfMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasColumnRankOfMatrix( EvalInvolution( M ) ) then
        return ColumnRankOfMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( ColumnRankOfMatrix,
        IsHomalgMatrix and HasEvalInvolution, 0,
        
  function( M )
    
    if HasRowRankOfMatrix( EvalInvolution( M ) ) then
        return RowRankOfMatrix( EvalInvolution( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( RowRankOfMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasRowRankOfMatrix( PreEval( M ) ) then
        return RowRankOfMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( ColumnRankOfMatrix,
        IsHomalgMatrix and HasPreEval, 0,
        
  function( M )
    
    if HasColumnRankOfMatrix( PreEval( M ) ) then
        return ColumnRankOfMatrix( PreEval( M ) );
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( PositionOfFirstNonZeroEntryPerRow,
        IsHomalgMatrix and HasEvalCertainRows, 0,
        
  function( M )
    local mat, pos;
    
    mat := EvalCertainRows( M )[1];
    
    if HasPositionOfFirstNonZeroEntryPerRow( mat ) then
        
        pos := PositionOfFirstNonZeroEntryPerRow( mat );
        
        return pos{ EvalCertainRows( M )[2] };
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( PositionOfFirstNonZeroEntryPerRow,
        IsHomalgMatrix and HasEvalCertainColumns and HasNrRows, 0,
        
  function( M )
    local mat, pos, plist;
    
    mat := EvalCertainColumns( M )[1];
    
    if HasPositionOfFirstNonZeroEntryPerRow( mat ) then
        
        pos := PositionOfFirstNonZeroEntryPerRow( mat );
        
        plist := EvalCertainColumns( M )[2];
        
        return List( [ 1 .. NrRows( M ) ], function( i ) if pos[i] in plist then return Position( plist, pos[i] ); else return 0; fi; end );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallImmediateMethod( ZeroRows,
        IsHomalgMatrix and HasPositionOfFirstNonZeroEntryPerRow and HasNrRows, 0,
        
  function( M )
    local pos;
    
    pos := PositionOfFirstNonZeroEntryPerRow( M );
    
    return Filtered( [ 1 .. NrRows( M ) ], i -> pos[i] = 0 );
    
end );

##
InstallImmediateMethod( ZeroColumns,
        IsHomalgMatrix and HasPositionOfFirstNonZeroEntryPerRow and IsSubidentityMatrix and HasNrColumns, 0,
        
  function( M )
    local pos;
    
    pos := PositionOfFirstNonZeroEntryPerRow( M );
    
    return Filtered( [ 1 .. NrColumns( M ) ], i -> not i in pos );
    
end );

####################################
#
# methods for operations:
#
####################################

#-----------------------------------
# Involution
#-----------------------------------

##
InstallMethod( Involution,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalInvolution ],
        
  function( M )
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: Involution( Involution )", "\033[0m" );
    
    return EvalInvolution( M );
    
end );

#-----------------------------------
# CertainRows
#-----------------------------------

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalCertainRows, IsList ],
        
  function( M, plist )
    local A, plistA;
    
    if not HasEval( M ) then ## otherwise we would take CertainRows of a bigger matrix
        
        if not IsSubset( [ 1 .. NrRows( M ) ], plist ) then
            Error( "the list of row positions ", plist, " must be in the range [ 1 .. ", NrRows( M ), " ]\n" );
        fi;
        
        if NrRows( M ) = 0 or plist = [ 1 .. NrRows( M ) ] then
            return M;
        fi;
        
        Info( InfoCOLEM, 4, COLEM.color, "COLEM: CertainRows( CertainRows )", "\033[0m" );
        
        A := EvalCertainRows( M )[1];
        plistA := EvalCertainRows( M )[2];
        
        return CertainRows( A, plistA{plist} );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalCertainColumns, IsList ],
        
  function( M, plist )
    local A, plistA;
    
    if not HasEval( M ) then ## otherwise we would take CertainRows of a bigger matrix
        
        if not IsSubset( [ 1 .. NrRows( M ) ], plist ) then
            Error( "the list of row positions ", plist, " must be in the range [ 1 .. ", NrRows( M ), " ]\n" );
        fi;
        
        if NrRows( M ) = 0 or plist = [ 1 .. NrRows( M ) ] then
            return M;
        fi;
        
        A := EvalCertainColumns( M )[1];
        plistA := EvalCertainColumns( M )[2];
        
        if Length( plist ) * NrColumns( A ) < Length( plistA ) * NrRows( A ) then
            
            Info( InfoCOLEM, 4, COLEM.color, "COLEM: CertainRows( CertainColumns )", "\033[0m" );
            
            return CertainColumns( CertainRows( A, plist ), plistA );
            
        fi;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalUnionOfRows, IsList ],
        
  function( M, plist )
    local A, B, rowsA, rowsB, plistA, plistB;
    
    if not IsSubset( [ 1 .. NrRows( M ) ], plist ) then
        Error( "the list of row positions ", plist, " must be in the range [ 1 .. ", NrRows( M ), " ]\n" );
    fi;
        
    if NrRows( M ) = 0 or plist = [ 1 .. NrRows( M ) ] then
        return M;
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: CertainRows( UnionOfRows )", "\033[0m" );
    
    A := EvalUnionOfRows( M )[1];
    B := EvalUnionOfRows( M )[2];
    
    rowsA := [ 1 .. NrRows( A ) ];
    rowsB := [ 1 .. NrRows( B ) ];
    
    plistA := Filtered( plist, x -> x in rowsA );		## CAUTION: don't use Intersection(2)
    plistB := Filtered( plist - NrRows( A ), x -> x in rowsB );	## CAUTION: don't use Intersection(2)
    
    return UnionOfRows( CertainRows( A, plistA ), CertainRows( B, plistB ) );
    
end );

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalUnionOfColumns, IsList ],
        
  function( M, plist )
    local A, B;
    
    if not IsSubset( [ 1 .. NrRows( M ) ], plist ) then
        Error( "the list of row positions ", plist, " must be in the range [ 1 .. ", NrRows( M ), " ]\n" );
    fi;
    
    if NrRows( M ) = 0 or plist = [ 1 .. NrRows( M ) ] then
        return M;
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: CertainRows( UnionOfColumns )", "\033[0m" );
    
    A := EvalUnionOfColumns( M )[1];
    B := EvalUnionOfColumns( M )[2];
    
    return UnionOfColumns( CertainRows( A, plist ), CertainRows( B, plist ) );
    
end );

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalCompose, IsList ],
        
  function( M, plist )
    local A, B;
    
    if not IsSubset( [ 1 .. NrRows( M ) ], plist ) then
        Error( "the list of row positions ", plist, " must be in the range [ 1 .. ", NrRows( M ), " ]\n" );
    fi;
    
    if NrRows( M ) = 0 or plist = [ 1 .. NrRows( M ) ] then
        return M;
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: CertainRows( Compose )", "\033[0m" );
    
    A := EvalCompose( M )[1];
    B := EvalCompose( M )[2];
    
    return CertainRows( A, plist ) * B;
    
end );

#-----------------------------------
# CertainColumns
#-----------------------------------

##
InstallMethod( CertainColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalCertainColumns, IsList ],
        
  function( M, plist )
    local A, plistA;
    
    if not HasEval( M ) then ## otherwise we would take CertainColumns of a bigger matrix
        
        if not IsSubset( [ 1 .. NrColumns( M ) ], plist ) then
            Error( "the list of column positions ", plist, " must be in the range [ 1 .. ", NrColumns( M ), " ]\n" );
        fi;
        
        if NrColumns( M ) = 0 or plist = [ 1 .. NrColumns( M ) ] then
            return M;
        fi;
        
        Info( InfoCOLEM, 4, COLEM.color, "COLEM: CertainColumns( CertainColumns )", "\033[0m" );
    
        A := EvalCertainColumns( M )[1];
        plistA := EvalCertainColumns( M )[2];
        
        return CertainColumns( A, plistA{plist} );
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( CertainColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalCertainRows, IsList ],
        
  function( M, plist )
    local A, plistA;
    
    if not HasEval( M ) then ## otherwise we would take CertainColumns of a bigger matrix
        
        if not IsSubset( [ 1 .. NrColumns( M ) ], plist ) then
            Error( "the list of column positions ", plist, " must be in the range [ 1 .. ", NrColumns( M ), " ]\n" );
        fi;
        
        if NrColumns( M ) = 0 or plist = [ 1 .. NrColumns( M ) ] then
            return M;
        fi;
        
        A := EvalCertainRows( M )[1];
        plistA := EvalCertainRows( M )[2];
        
        if Length( plist ) * NrRows( A ) < Length( plistA ) * NrColumns( A ) then
            
            Info( InfoCOLEM, 4, COLEM.color, "COLEM: CertainColumns( CertainRows )", "\033[0m" );
            
            return CertainRows( CertainColumns( A, plist ), plistA );
            
        fi;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( CertainColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalUnionOfColumns, IsList ],
        
  function( M, plist )
    local A, B, columnsA, columnsB, plistA, plistB;
    
    if not IsSubset( [ 1 .. NrColumns( M ) ], plist ) then
        Error( "the list of column positions ", plist, " must be in the range [ 1 .. ", NrColumns( M ), " ]\n" );
    fi;
    
    if NrColumns( M ) = 0 or plist = [ 1 .. NrColumns( M ) ] then
        return M;
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: CertainColumns( UnionOfColumns )", "\033[0m" );
    
    A := EvalUnionOfColumns( M )[1];
    B := EvalUnionOfColumns( M )[2];
    
    columnsA := [ 1 .. NrColumns( A ) ];
    columnsB := [ 1 .. NrColumns( B ) ];
    
    plistA := Filtered( plist, x -> x in columnsA );			## CAUTION: don't use Intersection(2)
    plistB := Filtered( plist - NrColumns( A ), x -> x in columnsB );	## CAUTION: don't use Intersection(2)
    
    return UnionOfColumns( CertainColumns( A, plistA ), CertainColumns( B, plistB ) );
    
end );

##
InstallMethod( CertainColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalUnionOfRows, IsList ],
        
  function( M, plist )
    local A, B;
    
    if not IsSubset( [ 1 .. NrColumns( M ) ], plist ) then
        Error( "the list of column positions ", plist, " must be in the range [ 1 .. ", NrColumns( M ), " ]\n" );
    fi;
    
    if NrColumns( M ) = 0 or plist = [ 1 .. NrColumns( M ) ] then
        return M;
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: CertainColumns( UnionOfRows )", "\033[0m" );
    
    A := EvalUnionOfRows( M )[1];
    B := EvalUnionOfRows( M )[2];
    
    return UnionOfRows( CertainColumns( A, plist ), CertainColumns( B, plist ) );
    
end );

##
InstallMethod( CertainColumns,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalCompose, IsList ],
        
  function( M, plist )
    local A, B;
    
    if not IsSubset( [ 1 .. NrColumns( M ) ], plist ) then
        Error( "the list of column positions ", plist, " must be in the range [ 1 .. ", NrColumns( M ), " ]\n" );
    fi;
        
    if NrColumns( M ) = 0 or plist = [ 1 .. NrColumns( M ) ] then
        return M;
    fi;
        
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: CertainColumns( Compose )", "\033[0m" );
    
    A := EvalCompose( M )[1];
    B := EvalCompose( M )[2];
    
    return A * CertainColumns( B, plist );
    
end );

#-----------------------------------
# AddMat
#-----------------------------------

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsHomalgMatrix and HasEvalCompose, IsHomalgMatrix and HasEvalCompose ],
        
  function( A, B )
    local C;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    C := EvalCompose( A )[1];
    
    if IsIdenticalObj( C , EvalCompose( B )[1] ) then
        
        Info( InfoCOLEM, 2, COLEM.color, "COLEM: C * E + C * F", "\033[0m" );
        
        return C * ( EvalCompose( A )[2] + EvalCompose( B )[2] );
        
    fi;
    
    C := EvalCompose( A )[2];
    
    if IsIdenticalObj( C , EvalCompose( B )[2] ) then
        
        Info( InfoCOLEM, 2, COLEM.color, "COLEM: E * C + F * C", "\033[0m" );
        
        return ( EvalCompose( A )[1] + EvalCompose( B )[1] ) * C;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsHomalgMatrix and HasEvalMulMat, IsHomalgMatrix ],
        
  function( A, B )
    local R;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    R := HomalgRing( A );
    
    if EvalMulMat( A )[1] = MinusOne( R ) then
        
        Info( InfoCOLEM, 2, COLEM.color, "COLEM: -A + B", "\033[0m" );
        
        return B - EvalMulMat( A )[2];
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and HasEvalMulMat ],
        
  function( A, B )
    local R;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    R := HomalgRing( B );
    
    if EvalMulMat( B )[1] = MinusOne( R ) then
        
        Info( InfoCOLEM, 2, COLEM.color, "COLEM: A + (-B)", "\033[0m" );
        
        return A - EvalMulMat( B )[2];
        
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# AdditiveInverseMutable
#-----------------------------------

## a synonym of `-<elm>':
InstallMethod( AdditiveInverseMutable,
        "of homalg matrices",
        [ IsHomalgMatrix and HasEvalMulMat ],
        
  function( A )
    local R;
    
    R := HomalgRing( A );
    
    if EvalMulMat( A )[1] = MinusOne( R ) then
        
        Info( InfoCOLEM, 2, COLEM.color, "COLEM: -(-IsHomalgMatrix)", "\033[0m" );
        
        return EvalMulMat( A )[2];
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# SubMat
#-----------------------------------

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsHomalgMatrix and HasEvalCompose, IsHomalgMatrix and HasEvalCompose ],
        
  function( A, B )
    local C;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    C := EvalCompose( A )[1];
    
    if IsIdenticalObj( C , EvalCompose( B )[1] ) then
        
        Info( InfoCOLEM, 2, COLEM.color, "COLEM: C * E - C * F", "\033[0m" );
        
        return C * ( EvalCompose( A )[2] - EvalCompose( B )[2] );
        
    fi;
    
    C := EvalCompose( A )[2];
    
    if IsIdenticalObj( C , EvalCompose( B )[2] ) then
        
        Info( InfoCOLEM, 2, COLEM.color, "COLEM: E * C - F * C", "\033[0m" );
        
        return ( EvalCompose( A )[1] - EvalCompose( B )[1] ) * C;
        
    fi;
    
    TryNextMethod( );
    
end );

#-----------------------------------
# Compose
#-----------------------------------

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix and HasEvalUnionOfRows, IsHomalgMatrix ],
        
  function( A, B )
    local A1, A2;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: UnionOfRows * IsHomalgMatrix", "\033[0m" );
    
    A1 := EvalUnionOfRows( A )[1];
    A2 := EvalUnionOfRows( A )[2];
    
    return UnionOfRows( A1 * B, A2* B );
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and HasEvalUnionOfColumns ],
        
  function( A, B )
    local B1, B2;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: IsHomalgMatrix * UnionOfColumns", "\033[0m" );
    
    B1 := EvalUnionOfColumns( B )[1];
    B2 := EvalUnionOfColumns( B )[2];
    
    return UnionOfColumns( A * B1, A * B2 );
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix and HasEvalUnionOfColumns, IsHomalgMatrix ],
        
  function( A, B )
    local A1, A2, B1, B2;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: UnionOfColumns * IsHomalgMatrix", "\033[0m" );
    
    A1 := EvalUnionOfColumns( A )[1];
    A2 := EvalUnionOfColumns( A )[2];
    
    B1 := CertainRows( B, [ 1 .. NrColumns( A1 ) ] );
    B2 := CertainRows( B, [ 1 .. NrColumns( A2 ) ] );
    
    return A1 * B1 +  A2 * B2;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsHomalgMatrix, IsHomalgMatrix and HasEvalUnionOfRows ],
        
  function( A, B )
    local B1, B2, A1, A2;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: IsHomalgMatrix * UnionOfRows", "\033[0m" );
    
    B1 := EvalUnionOfRows( B )[1];
    B2 := EvalUnionOfRows( B )[2];
    
    A1 := CertainColumns( A, [ 1 .. NrRows( B1 ) ] );
    A2 := CertainColumns( A, [ 1 .. NrRows( B2 ) ] );
    
    return A1 * B1 + A2 * B2;
    
end );

#-----------------------------------
# LeftInverse
#-----------------------------------

##
InstallMethod( LeftInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalRightInverse ], 1,
        
  function( M )
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: LeftInverse( RightInverse )", "\033[0m" );
    
    return EvalRightInverse( M );
    
end );

##
InstallMethod( LeftInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalInverse ], 2,
        
  function( M )
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: LeftInverse( Inverse )", "\033[0m" );
    
    return EvalInverse( M );
    
end );

#-----------------------------------
# RightInverse
#-----------------------------------

##
InstallMethod( RightInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalLeftInverse ], 1,
        
  function( M )
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: RightInverse( LeftInverse )", "\033[0m" );
    
    return EvalLeftInverse( M );
    
end );

##
InstallMethod( RightInverse,
        "for homalg matrices",
        [ IsHomalgMatrix and HasEvalInverse ], 2,
        
  function( M )
    
    Info( InfoCOLEM, 2, COLEM.color, "COLEM: RightInverse( Inverse )", "\033[0m" );
    
    return EvalInverse( M );
    
end );
