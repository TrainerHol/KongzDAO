//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library StructureHelpers {
    /**
     * @notice Concatenates a string JSON property
     * @dev Concatenates a new line with a JSON property.
     * @param propertyName The name of the property.
     * @param propertyValue The value of the property.
     */
    function propertyConcat(
        string memory self,
        string memory propertyName,
        string memory propertyValue
    ) internal pure returns (string memory) {
        self = string(abi.encodePacked(self, '"'));
        self = string(abi.encodePacked(self, propertyName));
        self = string(abi.encodePacked(self, '": '));
        self = string(abi.encodePacked(self, '"'));
        self = string(abi.encodePacked(self, propertyValue));
        self = string(abi.encodePacked(self, '"'));
        self = string(abi.encodePacked(self, ",\n"));
        return self;
    }

    /**
     * @notice Concatenates a string JSON property
     * @dev Concatenates a new line with a JSON property.
     * @param propertyName The name of the property.
     * @param propertyValue The value of the property.
     * @param isLast Does not add a comma at the end if true.
     */
    function propertyConcat(
        string memory self,
        string memory propertyName,
        string memory propertyValue,
        bool isLast
    ) internal pure returns (string memory) {
        self = string(abi.encodePacked(self, '"'));
        self = string(abi.encodePacked(self, propertyName));
        self = string(abi.encodePacked(self, '": '));
        self = string(abi.encodePacked(self, '"'));
        self = string(abi.encodePacked(self, propertyValue));
        self = string(abi.encodePacked(self, '"'));
        if (!isLast) {
            self = string(abi.encodePacked(self, ",\n"));
        }
        return self;
    }

    /**
     * @notice Concatenates a string JSON property
     * @dev Concatenates a new line with a JSON property as a numeric value.
     * @param propertyName The name of the property.
     * @param propertyValue The value of the property.
     */
    function propertyConcat(
        string memory self,
        string memory propertyName,
        uint256 propertyValue
    ) internal pure returns (string memory) {
        self = string(abi.encodePacked(self, '"'));
        self = string(abi.encodePacked(self, propertyName));
        self = string(abi.encodePacked(self, '": '));
        self = string(abi.encodePacked(self, propertyValue));
        self = string(abi.encodePacked(self, ",\n"));
        return self;
    }

    /**
     * @notice Concatenates a string JSON property
     * @dev Concatenates a new line with a JSON property.
     * @param propertyName The name of the property.
     * @param propertyValue The value of the property.
     * @param isLast Does not add a comma at the end if true.
     */
    function propertyConcat(
        string memory self,
        string memory propertyName,
        uint256 propertyValue,
        bool isLast
    ) internal pure returns (string memory) {
        self = string(abi.encodePacked(self, '"'));
        self = string(abi.encodePacked(self, propertyName));
        self = string(abi.encodePacked(self, '": '));
        self = string(abi.encodePacked(self, propertyValue));
        if (!isLast) {
            self = string(abi.encodePacked(self, ",\n"));
        }
        return self;
    }

    /** @dev Returns the string value of a uint256.
     */
    function toString(uint256 self)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (self == 0) {
            return "0";
        }
        uint256 j = self;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (self != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(self - (self / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            self /= 10;
        }
        return string(bstr);
    }
}
