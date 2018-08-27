<?php
define('ENV', 'online');
return array(
    'env' => ENV,
    'logger' => array(
        'level' => 'all', // none/off|(LEVEL)
        'dump' => 'file', // none|html|file, 可用'|'组合
        'files' => array( // ALL|(LEVEL)
            #'ALL'	=> dirname(__FILE__) . '/../../logs/' . date('Y-m') . '.log',
        ),
    ),
    'servers' => array(
        array(
            'host' => 'ssdb',
            'port' => '8888',
            'password' => '',
        ),
    ),
    'login' => array(
        'name' => 'admin',
        'password' => 'password', // at least 6 characters
    ),
);
