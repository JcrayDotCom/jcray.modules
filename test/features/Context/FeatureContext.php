<?php

use Behat\Behat\Context\Context;
use Sanpi\Behatch\Context\BehatchContext;

class FeatureContext implements Context
{
    public function __construct(array $parameters)
    {
        $this->useContext('behatch', new BehatchContext($parameters));
    }
}
