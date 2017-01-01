%
% (c) Microsoft Corporation. All rights reserved. 
%
function setEnvironment(property_,value)

global ENV
if isempty(ENV)
  % initialise
  ENV.logID	= 1;
end
c_	= sprintf('ENV.%s = value;', property_);
eval(c_);
