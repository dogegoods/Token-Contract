// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Treasury {
    address private _owner;

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        _owner = msg.sender;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Withdraws tokens and self-destructs the contract.
     */
    function withdraw(address token, address payable recipient) external onlyOwner {
        require(IERC20(token).balanceOf(address(this)) > 0, "No tokens locked");
        IERC20(token).transfer(recipient, IERC20(token).balanceOf(address(this)));
        selfdestruct(payable(msg.sender));
    }
    
    receive() external payable {}
}
