function tile(figs)

% TILEFIGS Tile all open figure windows around on the screen.
%
%   TILEFIGS places all open figure windows around on the screen with no
%   overlap.
%
%   TILEFIGS(FIGS) can be used to specify which figures that should be
%   tiled. Figures are not sorted when specified.
%
%   See also SORTFIGS, CYCLEFIGS.

%   Author:	 Peter J. Acklam
%   Time-stamp:	 2003-10-13 15:40:11 +0200
%   E-mail:	 pjacklam@online.no
%   URL:	 http://home.online.no/~pjacklam

%   Mod by jordi@uv.es, to handle my particular two monitors linux setup

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the handles to the figures to process.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~nargin				% If no input arguments...
   figs = findobj('Type', 'figure');	% ...find all figures.
   figs	= sort(figs);
end

if isempty(figs)
   disp('No open figures or no figures specified.');
   return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The elements in the vector specifying the position.
% 1 - Window left position
% 2 - Window bottom position
% 3 - Window horizontal size
% 4 - Window vertical size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hspc   = 20;		 % Horisontal space.
topspc = 20;		 % Space above top figure.
medspc = 20;		 % Space between figures.
botspc = 40;		 % Space below bottom figure.

units	= 'pixels';

% hspc   = 0.02;		% Horisontal space.
% topspc = 0.02;		% Space above top figure.
% medspc = 0.02;		% Space between figures.
% botspc = 0.05;		% Space below bottom figure.
% 
% units  = 'normalized';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set miscellaneous parameter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nfigs = length(figs);		% Number of figures.

nh = ceil(sqrt(nfigs));		% Number of figures horisontally.
nv = ceil(nfigs / nh);		% Number of figures vertically.

nh = max(nh, 2);
nv = max(nv, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the screen size.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

old_root_units = get(0, 'Units');	% Get current root units.
set(0, 'Units', units);             % Set root units.
scrdim = get(0, 'ScreenSize');		% Get screen size.
set(0, 'Units', old_root_units);	% Reset units.
scrwid = scrdim(3);                 % Screen width.
scrhgt = scrdim(4);                 % Screen height.

scrwof = 0;
%if scrwid > 1280
%    scrwof = scrwid/2;
%    scrwid = scrwid - scrwof;
%end

figwid = (scrwid - (nh + 1) * hspc) / nh;
fighgt = (scrhgt - (topspc + botspc) - (nv - 1) * medspc) / nv;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Put the figures where they belong.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for row = 1 : nv
    for col = 1 : nh
        idx = (row - 1) * nh + col;
        if idx <= nfigs
            figlft = col * hspc + (col - 1) * figwid + scrwof;
            figbot = scrhgt - topspc - row * fighgt - (row - 1) * medspc;
            figpos = [ figlft figbot figwid fighgt ];    % Figure position.
            fighnd = figs(idx);                          % Figure handle.
            old_fig_units = get(fighnd, 'Units');	     % Get current units.
            set(fighnd, 'Units', units);                 % Set new units.
            set(fighnd, 'OuterPosition', figpos);	     % Set position.
            set(fighnd, 'Units', old_fig_units);	     % Reset units.
            figure(fighnd);                              % Raise figure.
        end
    end
end
