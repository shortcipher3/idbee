function [percentcorrect classes]=classifytestdata(samples,...
    samplesgroups, training,traininggroups,classifyfnc)
classes = classifyfnc(samples, training, traininggroups);
percentcorrect=sum(bsxfun(@eq,classes,samplesgroups))/length(samplesgroups);
end