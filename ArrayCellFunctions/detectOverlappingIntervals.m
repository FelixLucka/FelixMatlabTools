function bool = detectOverlappingIntervals(AB)
%DETECTOVERLAPPINGINTERVALS checks whether given intervals overlap
%
% DESCRIPTION: 
%   DetectOverlappingIntervals.m can be used to check if intervals given as
%   a two-dim array overlap
%
% USAGE:
%   detectOverlappingIntervals([1 2;3 4]) returns false
%   detectOverlappingIntervals([1 3;2 4]) returns true
%
% INPUTS:
%   AB - intervals given as [a1, b1; a2, b2; a3, b3; ...]
%
% OUTPUTS:
%   bool - boolean indicating whether the intervals in AB overlap
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also

bool = false;

% sort
AB = sort(AB,2);
AB = sortrows(AB);
for i=1:size(AB,1)-1
   if(any(any(AB(i+1:end,:) < AB(i,2))))
       bool = true;
       break
   end
end

end