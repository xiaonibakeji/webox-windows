<?php

$order = '99';
$service = 'WeBox-Nginx';

build_config(
    WB_CFG.'/nginx',
    WB_ETC.'/nginx',
    array(
        '{WB.IPN}' => WB_IPN,
        '{WB.TMP}' => WB_DAT,
        '{WB.WEB}' => WB_WEB,
    )
);
