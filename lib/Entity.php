<?php

namespace iTRON\cf7Telegram;

use iTRON\CF7TG\wpConnectionsClient;

abstract class Entity {
	/**
	 * @var wpConnectionsClient $connectionsClient
	 */
	protected $connectionsClient;

	/**
	 * @var Logger $logger
	 */
	protected $logger;

	public function __construct() {
		$this->connectionsClient = wpConnectionsClient::getInstance();
		$this->logger = new Logger();
	}
}