%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the use of the functions is Structs/
%
%
% ABOUT:
% 	author          - Felix Lucka
% 	date            - 11.01.2019
%  	last update     - 22.10.2023
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ccc

%% 

% emptyStruct produces a variable of type struct with no fields or data
s1 = emptyStruct
s2 = emptyStruct

s1.A = 1;
s2.A = 2;
s2.B = 3;

% overwrite all matching fields of s1 by those of s2 and add/don't add fields
% that s1 does not have
overwriteFields(s1, s2, 1) 
overwriteFields(s1, s2, 0) 

% removeFields extends the native rmfield by not throwing an error if the
% struct does not have a field with the corresponding name
s2 = removeFields(s2, {'A', 'C'})

%mergeStructs merges two structs that have no field names in common
s3 = mergeStructs(s1, s2)

% listDifferentFields lists the field names that two structs don't share
listDifferentFields(s1, 'S1', s3, 'S3')

s3.C = 5
% extractFields extracts a subset of fields from a struct
s4 = extractFields(s3, {'A', 'B'})


% enforceFields checks if a struct has certain fields and throws an error
% otherwise
enforceFields(s4, 'S4', {'A', 'B'})
enforceFields(s4, 'S4', {'A', 'B', 'C'})

%%

% compareStructs compares two structs to decide whether they are equal
s4.C = 5 
% s3 and s4 are identical
compareStructs(s3, 'S3', s4, 'S4')

s4.C = 5.01;
% s3 and s4 are not identical and we print output
compareStructs(s3, 'S3', s4, 'S4', {}, 0, 1);

% s3 and s4 are not identical but we omit the comparison of field C
compareStructs(s3, 'S3', s4, 'S4', {'C'})

% s3 and s4 are not identical but we set the numerical tolerance for the
% comparison between the values of field C (5 and 5.01) such that they will
% pass as equal within the tolerance
compareStructs(s3, 'S3', s4, 'S4', {}, 0.1)
