function [ac,Taus] = autocorr(f,varargin)

[sizes{1:nargin-1}]=size(varargin{1});
t=cell(1,nargin-1);
for i=1:nargin-1
    ind=prod(cell2mat(sizes(1:i-1)));
    Ts = varargin{i}(ind+1)-varargin{i}(1);
    Rng = max(varargin{i}(:))-min(varargin{i}(:));
    t{i} = -Rng:Ts:Rng;
end
if nargin==2     % 1D
    ac = xcorr(f);
elseif nargin==3 % 2D
    ac = xcorr2(f);
else             % 3D
    ac = convn(f,f(end:-1:1,end:-1:1,end:-1:1));
end
ac = ac/max(ac(:));
[Taus{1:length(varargin)}] = ndgrid(t{:});
