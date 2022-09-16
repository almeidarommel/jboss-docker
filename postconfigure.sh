#!/usr/bin/env bash
#set -x
#echo "Executing postconfigure.sh"
#$JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/extensions/extensions.cli
#$JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/extensions/keystore-cacerts.cli
#$JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/extensions/datasource.cli
set -x
echo "Executing postconfigure.sh"

for cli_file in $JBOSS_HOME/extensions/*.cli;
do
  echo "Arquivo sendo executado: ${cli_file}"
  $JBOSS_HOME/bin/jboss-cli.sh --file="${cli_file}"
done

