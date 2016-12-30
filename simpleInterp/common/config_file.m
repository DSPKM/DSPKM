%% Data load setup
gendatafuncs = {@genDataInterp, @genDataDeconv, @genDataUltrasound, ...
    @genDataHRV, @genDataOFDM, @genDataSpectral, @genDataDopplerCardiac, ...
    @genDataEAM, @genDataMAE, @genDataIndoorLocation};
conf.data.loadDataFuncName = gendatafuncs{ind_datafunc};

%% Vectors to evaluate different experimental conditions
conf.varname_loop1 = 'idle1';
conf.vector_loop1 = 1;
conf.varname_loop2 = 'idle2';
conf.vector_loop2 = 1;

switch func2str(conf.data.loadDataFuncName)
    case 'genDataInterp'
        config_interp
        config_interp_SVM
    case 'genDataDeconv'
        config_deconv
        config_deconv_AKSM
    case 'genDataUltrasound'
        config_ultrasound
    case 'genDataHRV'
        config_HRV
    case 'genDataOFDM'
        config_OFDM
    case 'genDataSpectral'
        config_spectral
    case 'genDataDopplerCardiac'
        config_dopplerCardiac
    case 'genDataEAM'
        config_EAM
    case 'genDataMAE'
        config_MAE
    case 'genDataIndoorLocation'
        config_indoorLocation
end