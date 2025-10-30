// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RentChain
 * @dev A decentralized rental payment system where tenants can pay rent
 * directly to landlords through Ethereum smart contracts.
 */
contract RentChain {
    address public owner;
    uint256 public propertyCount = 0;

    struct Property {
        uint256 id;
        address landlord;
        address tenant;
        uint256 rentAmount;
        uint256 dueDate;
        bool isActive;
    }

    mapping(uint256 => Property) public properties;

    event PropertyListed(uint256 indexed propertyId, address indexed landlord, uint256 rentAmount);
    event RentPaid(uint256 indexed propertyId, address indexed tenant, uint256 amount);
    event TenantAssigned(uint256 indexed propertyId, address indexed tenant);
    event ContractTerminated(uint256 indexed propertyId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this");
        _;
    }

    modifier onlyLandlord(uint256 _propertyId) {
        require(properties[_propertyId].landlord == msg.sender, "Only landlord can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Landlord lists a new property for rent.
     * @param _rentAmount Monthly rent amount (in wei).
     * @param _dueDate Rent due date (as a Unix timestamp).
     */
    function listProperty(uint256 _rentAmount, uint256 _dueDate) external {
        require(_rentAmount > 0, "Rent must be greater than 0");
        require(_dueDate > block.timestamp, "Due date must be in the future");

        propertyCount++;
        properties[propertyCount] = Property({
            id: propertyCount,
            landlord: msg.sender,
            tenant: address(0),
            rentAmount: _rentAmount,
            dueDate: _dueDate,
            isActive: true
        });

        emit PropertyListed(propertyCount, msg.sender, _rentAmount);
    }

    /**
     * @dev Assigns a tenant to a listed property.
     * @param _propertyId The ID of the property.
     * @param _tenant The address of the tenant.
     */
    function assignTenant(uint256 _propertyId, address _tenant) external onlyLandlord(_propertyId) {
        Property storage prop = properties[_propertyId];
        require(prop.isActive, "Property not active");
        require(prop.tenant == address(0), "Tenant already assigned");

        prop.tenant = _tenant;
        emit TenantAssigned(_propertyId, _tenant);
    }

    /**
     * @dev Tenant pays rent to the landlord.
     * @param _propertyId The ID of the property.
     */
    function payRent(uint256 _propertyId) external payable {
        Property storage prop = properties[_propertyId];
        require(prop.isActive, "Property not active");
        require(msg.sender == prop.tenant, "Only assigned tenant can pay rent");
        require(msg.value == prop.rentAmount, "Incorrect rent amount");
        require(block.timestamp <= prop.dueDate, "Rent payment is overdue");

        payable(prop.landlord).transfer(msg.value);
        emit RentPaid(_propertyId, msg.sender, msg.value);
    }

    /**
     * @dev Landlord terminates a rental contract.
     * @param _propertyId The ID of the property.
     */
    function terminateContract(uint256 _propertyId) external onlyLandlord(_propertyId) {
        Property storage prop = properties[_propertyId];
        require(prop.isActive, "Property already inactive");

        prop.isActive = false;
        emit ContractTerminated(_propertyId);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RentChain
 * @dev A decentralized rental payment system where tenants can pay rent
 * directly to landlords through Ethereum smart contracts.
 */
contract RentChain {
    address public owner;
    uint256 public propertyCount = 0;

    struct Property {
        uint256 id;
        address landlord;
        address tenant;
        uint256 rentAmount;
        uint256 dueDate;
        bool isActive;
    }

    mapping(uint256 => Property) public properties;

    event PropertyListed(uint256 indexed propertyId, address indexed landlord, uint256 rentAmount);
    event RentPaid(uint256 indexed propertyId, address indexed tenant, uint256 amount);
    event TenantAssigned(uint256 indexed propertyId, address indexed tenant);
    event ContractTerminated(uint256 indexed propertyId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this");
        _;
    }

    modifier onlyLandlord(uint256 _propertyId) {
        require(properties[_propertyId].landlord == msg.sender, "Only landlord can call this");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Landlord lists a new property for rent.
     * @param _rentAmount Monthly rent amount (in wei).
     * @param _dueDate Rent due date (as a Unix timestamp).
     */
    function listProperty(uint256 _rentAmount, uint256 _dueDate) external {
        require(_rentAmount > 0, "Rent must be greater than 0");
        require(_dueDate > block.timestamp, "Due date must be in the future");

        propertyCount++;
        properties[propertyCount] = Property({
            id: propertyCount,
            landlord: msg.sender,
            tenant: address(0),
            rentAmount: _rentAmount,
            dueDate: _dueDate,
            isActive: true
        });

        emit PropertyListed(propertyCount, msg.sender, _rentAmount);
    }

    /**
     * @dev Assigns a tenant to a listed property.
     * @param _propertyId The ID of the property.
     * @param _tenant The address of the tenant.
     */
    function assignTenant(uint256 _propertyId, address _tenant) external onlyLandlord(_propertyId) {
        Property storage prop = properties[_propertyId];
        require(prop.isActive, "Property not active");
        require(prop.tenant == address(0), "Tenant already assigned");

        prop.tenant = _tenant;
        emit TenantAssigned(_propertyId, _tenant);
    }

    /**
     * @dev Tenant pays rent to the landlord.
     * @param _propertyId The ID of the property.
     */
    function payRent(uint256 _propertyId) external payable {
        Property storage prop = properties[_propertyId];
        require(prop.isActive, "Property not active");
        require(msg.sender == prop.tenant, "Only assigned tenant can pay rent");
        require(msg.value == prop.rentAmount, "Incorrect rent amount");
        require(block.timestamp <= prop.dueDate, "Rent payment is overdue");

        payable(prop.landlord).transfer(msg.value);
        emit RentPaid(_propertyId, msg.sender, msg.value);
    }

    /**
     * @dev Landlord terminates a rental contract.
     * @param _propertyId The ID of the property.
     */
    function terminateContract(uint256 _propertyId) external onlyLandlord(_propertyId) {
        Property storage prop = properties[_propertyId];
        require(prop.isActive, "Property already inactive");

        prop.isActive = false;
        emit ContractTerminated(_propertyId);
    }
}

