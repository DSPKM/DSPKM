function myeb(Y,S,options)
%
% myeb(Y,S,options);
%
% This function makes nice coloured, shaded error bars. Exactly what
% it does depends on Y, and on whether you give it one or two inputs.
%
% If you only pass it Y, and no other arguments, it assumed you're
% giving it raw data.
%
%		myeb(Raw_Data)
%
% 	.) if Y is 2D array, it will then plot mean(Y) with errorbars given
% 	by std(Y). In this case there is only one mean vector with its
% 	errorbars.
%
%	.) if Y is 3D array, it will plot size(Y,3) lines with the
%	associated errorbars. Line k will be mean(Y(:,:,k)) with errorbars
%	given by std(Y(:,:,k))
%
% If you pass it 2 arguments, each has to be at most 2D.
%
%		myeb(mu,std)
%
% 	.) if mu and std are 1D, it just plots one line given by mu with a
% 	shaded region given by std.
%
%	.) if mu and std are 2D, it will plot size(Y,2) lines in the
%	standard sequence of colours; each line mu(:,k) will have a shaded
%	region in the same colour, but less saturated given by std(:,k)
%
% Quentin Huys, 2007
% Center for Theoretical Neuroscience, Columbia University
% Email: qhuys [at] n e u r o theory [dot] columbia.edu
% (just get rid of the spaces, replace [at] with @ and [dot] with .)
%
% Jordi (jordi@uv.es), 2010/11
% Added: transparency, proper legends and colors, ...
%
% options struct:
%   - x: array with x index
%   - 
%   - styles: cell with plot styles
%   - legends: cell with plot legends

kk=0.4; % the higher the more transparency

% Define empty options struct to avoid errors
if ~exist('options','var')
    options = struct;
end

if isfield(options,'colors')
    col = options.colors;
else
    col  = [0 0 1; 0 .5 0; 1 0 0; 0 1 1; 1 0 1; 1 .5 0; 1 .5 1; 0 0 0];
end
ccol = col;
ccol(ccol>1) = 1;

if nargin == 1

    if length(size(Y)) == 2
        % We have only Y and it is 2-D => compute mean and std and call ourselves again
        myeb(mean(Y), std(Y), options)
        
    elseif length(size(Y))>2
        % 3-D data
        cla; hold on;
        ind1 = 1:size(Y,2);
        ind2 = ind1(end:-1:1);
        % Use jet colormap if more curves than colors defined
        if size(Y,3) > size(col,1);
            col = jet(size(Y,3));
            ccol = col + kk;
            ccol(ccol>1) = 1;
        end
        % Draw standard deviation fill
        for k = 1:size(Y,3)
            m = mean(Y(:,:,k));
            s = std(Y(:,:,k));
            h = fill([ind1 ind2],[m-s m(ind2)+s(ind2)],ccol(k,:));
            set(h,'edgecolor',ccol(k,:))
        end
        % Draw curve
        for k = 1:size(Y,3)
            m = mean(Y(:,:,k));
            plot(ind1,m,'-','linewidth',4,'color',col(k,:))
        end
        hold off
        
    end

elseif isstruct(S)
    % Second argument is 'options' instead of the standard deviation
    myeb(mean(Y),std(Y),S)
else

    if length(size(Y))>2
        error('length(size(Y)>2)');
        
    %elseif min(size(Y)) == 1;
    %    
    %    if size(m,1)>1; m = m';s = s';end
    %    ind1 = 1:length(m);
    %    ind2 = ind1(end:-1:1);
    %    hold on; h = fill([ind1 ind2],[m-s m(ind2)+s(ind2)],ccol(1,:));
    %    set(h,'edgecolor',ccol(1,:),'facealpha',0.5);
    %    plot(ind1,m,'linewidth',2,'color',col(1,:))
    %    hold off

    else
        
        if size(Y,1) == 1
            Y = Y';
            S = S';
        end

        m = Y;
        s = S;
        
        ind1 = 1:size(Y,1);
        ind2 = ind1(end:-1:1);

        xtd = ind1;
        if isfield(options,'x')
            xtd = options.x;
        end
        xtr = xtd(end:-1:1);
        
        cla; hold on;
        % Use jet color map if we have more curves than colors
        if size(Y,2) > size(col,1);
            col = jet(size(Y,2));
            ccol = col + kk;
            ccol(ccol > 1) = 1;
        end
        % Draw standard deviation fill
        for k = 1:size(Y,2)
            mm = m(:,k)';
            ss = s(:,k)';
            h = fill([xtd xtr],[mm-ss mm(ind2)+ss(ind2)],ccol(k,:));
            set(h,'edgecolor',ccol(k,:)) %,'facealpha',0.5)
        end

        % Curve styles
        if isfield(options,'styles')
            styles = options.styles;
        else
            styles = cell(1,size(Y,2));            
        end
        
        % Draw curves
        hn = zeros(1,size(Y,2));
        for k = 1:size(Y,2)
            mm = m(:,k)';
            if k > length(styles) || isempty(styles{k})
                styles{k} = '-';
            end
            hn(k) = plot(xtd,mm,styles{k},'linewidth',4,'color',col(k,:));
        end
        
        % Legends
        if isfield(options,'legends')
           legend(hn, options.legends)
        end
        
        hold off
        
    end
    
end
