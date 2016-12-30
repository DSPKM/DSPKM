s = log(sqrt((1+cos(t))/(1-cos(t))))
ds = diff(s)

pretty(ds)
simple(ds)
pretty(simple(ds))