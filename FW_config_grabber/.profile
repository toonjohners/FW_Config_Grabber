ORACLE_BASE=/opt/oracle; export ORACLE_BASE
ORACLE_HOME=/opt/oracle/product/11.2.0/client_1; export ORACLE_HOME
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN
LD_LIBRARY_PATH=$ORACLE_HOME/lib; export LD_LIBRARY_PATH
EDITOR=vi; export EDITOR
umask 022

ulimit -c unlimited

# JAVA settings
JAVA_HOME=/usr/java/jdk1.6.0_32
export JAVA_HOME

# PATHs
PATH=:$PATH:$JAVA_HOME/bin:$ORACLE_HOME/bin::/usr/sbin:/opt/VRTSvcs/bin:/sbin
#:/home/fworks/SCRIPTS:/usr/sbin

export PATH
#export CLASSPATH=$CLASSPATH:$ORACLE_HOME/oui/jlib/classes12.jar:$ORACLE_HOME/jdbc/lib/ojdbc6.jar:

###############################################################################
###   F U S I O N W O R K S    S E T T I N G S
###############################################################################
FUSIONWORKS_PROD=/fwdata/openet/fw/product
FUSIONWORKS_HOME=/fwdata/openet/fw/home
FUSIONWORKS_BASE_PATH=/fwdata/openet/fw/base
FW_BASE_PATH=$FUSIONWORKS_BASE_PATH

FW_CONSOLE_PORT_ON=1
export FUSIONWORKS_PROD FUSIONWORKS_HOME \
       FW_CONSOLE_PORT_ON FUSIONWORKS_BASE_PATH \
       FW_BASE_PATH


###############################################################################
###   U S E R    S E T T I N G S
###############################################################################

# Terminal settings
TERM=xterm
TERMINAL_EMULATOR=xterm
export TERM TERMINAL_EMULATOR
# Common aliases
alias ll='ls -la'
alias l='ls -ltrp'
alias cls='clear'

# Extra aliases
alias ERR='grep "ERROR\|FATAL\|Exception" $FUSIONWORKS_HOME/UnifiedLogging/UL_* | more'
alias ERR2='grep "ERROR\|FATAL\|Exception" $FUSIONWORKS_HOME/UnifiedLogging/UL_$(date +"%Y%m%d")
* | awk '\''BEGIN { FS = "," } ; { print $12 }'\'' |uniq -c | more'
alias read='| awk '\''BEGIN { FS = "," } ; { print $12 }'\'' | more'
alias cdlogs='cd $FUSIONWORKS_HOME/UnifiedLogging/'
alias soapui='/home/fworks/atf/SoapUI/soapui-4.5.1/bin/soapui.sh'
alias health='/opt/fworks/fw/base/Scripts/Health/health.sh'

# Prompt
#PS1="\u@\h\$ "
PS1="\u@\h:\w$ "
export PS1

# Sourcing of FW profile
if [ -f "$FUSIONWORKS_HOME/config/fw.profile" ]; then
     . $FUSIONWORKS_HOME/config/fw.profile
else
     echo " ...no fw.profile found"
fi

if [ -f ${HOME}/.shell_functions ]
then
        source ${HOME}/.shell_functions
fi
# Required for SQLPLUS to support characters
export NLS_LANG=american_america.WE8ISO8859P15
