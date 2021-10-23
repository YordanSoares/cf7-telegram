<?php

namespace iTRON\cf7Telegram;

use Ramsey\Collection\Collection;
use wppaCollectionFromConnectionsTrait;

class ChatCollection extends Collection {
	use wppaCollectionFromConnectionsTrait;

	function __construct( array $data = [] ) {
		$collectionType = __NAMESPACE__ . '\Chat';
		parent::__construct( $collectionType, $data );
	}
}