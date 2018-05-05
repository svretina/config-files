# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias l='ls -larht'
alias matlab='sudo /opt/MATLAB/R2016a/bin/matlab -nosplash' # add the -nodesktop options for terminal mode


#unlimited size of matrices else-->segmentation faults
ulimit -s unlimited
