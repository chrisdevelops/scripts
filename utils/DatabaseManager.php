<?php

use PDO;
use PDOException;

class DatabaseManager
{
    /** var string $dbhost */
    private $dbhost = DB_HOST;
    
    /** var string $dbuser */
    private $dbuser = DB_USER;
    
    /** var string $dbpass */
    private $dbpass = DB_PASS;
    
    /** var string $dbname */
    private $dbname = DB_NAME;

    /** var string $statement */
    private $statement;  

    /**
     * Database Constructor.
     */
    public function __construct()
    {
        $dsn = 'mysql:host=' . $this->dbhost . ';dbname=' . $this->dbname;  
        $options = [  
            PDO::ATTR_PERSISTENT => true,
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_EMULATE_PREPARES => true
        ];

        try {  
            $this->handler = new PDO($dsn, $this->dbuser, $this->dbpass, $options);
        } catch (PDOException $e) {  
            $this->error = $e->getMessage();  
        }
    }

    /**
     * Prepare queries to be executed.
     * 
     * @param string $query
     * @return DatabaseManager $this
     */
    public function query($query) : DatabaseManager
    { 
        $this->statement = $this->handler->prepare($query);

        return $this;
    }  

    /**
     * Bind the value to the query parameter.
     *
     * @param string $param the parameter name
     * @param mixed  $value the parameter value
     * @param mixed  $type  the parameter type
     * 
     * @return bool
     */
    public function bind($param, $value, $type = null) : bool
    {  
        if (is_null($type)) {  
            switch (true) {  
                case is_int($value):  
                    $type = PDO::PARAM_INT;  
                    break;  
                case is_bool($value):  
                    $type = PDO::PARAM_BOOL;  
                    break;  
                case is_null($value):  
                    $type = PDO::PARAM_NULL;  
                    break;  
                default:  
                    $type = PDO::PARAM_STR;  
            }  
        }

        return $this->statement->bindValue($param, $value, $type);
    } 

    /**
     * Execute the prepared statement.
     */
    public function execute()
    {  
        $this->statement->execute();

        return $this;
    }  

    /**
     * Execute the prepared statement and return the result set.
     * 
     * @return array
     */
    public function all() : array
    {  
        $this->execute();

        return $this->statement->fetchAll(PDO::FETCH_ASSOC);  
    }  

    /**
     * Execute the prepared statement and return the first result.
     * 
     * @return array
     */
    public function one() : array
    {  
        $this->execute();

        return $this->statement->fetch(PDO::FETCH_ASSOC);  
    } 

    /**
     * Get the number of rows returned from a query.
     * 
     * @return int
     */
    public function count() : int
    {
        $this->execute();

        return $this->statement->rowCount();  
    } 

    /**
     * Get the last insert ID.
     * 
     * @return int
     */
    public function lastId() : int
    {  
        return $this->handler->lastInsertId();  
    }  

    /**
     * Begin a PDO trransaction.
     * 
     * @return bool
     */
    public function beginTransaction() : bool
    {  
        return $this->handler->beginTransaction();  
    }  

    /**
     * End a PDO transaction
     * 
     * @return bool
     */
    public function endTransaction() : bool
    {  
        return $this->handler->commit();  
    }  

    /**
     * Abort a PDO transaction.
     * 
     * @return bool
     */
    public function cancelTransaction() : bool
    {  
        return $this->handler->rollBack();  
    }  
}