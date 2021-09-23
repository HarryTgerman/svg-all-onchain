// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "base64-sol/base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./HexStrings.sol";
import "./ToColor.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Uniswap NFT
library MetadataGenerator {
    using Strings for uint256;
    using HexStrings for uint160;
    using ToColor for bytes3;

    function statsBar(uint chubbiness) internal pure returns (string memory) {
        string memory line = '<line x1="0" y1="300" x2="400" y2="300" stroke="black" />';
        string memory text = string(abi.encodePacked('<text x="50%" y="350" class="base" dominant-baseline="middle" text-anchor="middle">chubbiness: ', chubbiness.toString(), '</text>'));
        return string(abi.encodePacked(line, text));
    }

    function batchGenerator(uint8 batch) internal pure returns (string memory) {
        string memory encodedSVG = "";
        if (batch == 1) {
            encodedSVG = '<polygon points="9.9, 1.1, 3.3, 21.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78" style="fill-rule:nonzero;"/>';
            return encodedSVG;
        } else if (batch == 2) {
            encodedSVG = '<polygon points="9.9, 1.1, 3.3, 21.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78" style="fill-rule:nonzero;"/><polygon points="40, 1.1, 3.3, 79.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78" style="fill-rule:nonzero;"/>';
            return encodedSVG;
        } else {
            return encodedSVG;
        }
    }

    function getColor(uint8 colorindex) internal pure returns (string memory) {
        if (colorindex == 1) {
            return "ffffff";
        } else if (colorindex == 2) {
            return "FF78A9";
        } else {
            return "000000";
        }
    }

    function tokenURI(
        address owner,
        uint256 tokenId,
        uint8 color,
        uint256 chubbiness,
        uint8 batch
    ) internal pure returns (string memory) {
        string memory imageURI = svgToImageURI(
            owner,
            tokenId,
            color,
            chubbiness,
            batch
        );
        return formatTokenURI(imageURI);
    }

    function svgToImageURI(
        address owner,
        uint256 tokenId,
        uint8 color,
        uint256 chubbiness,
        uint8 batch
    ) public pure returns (string memory) {
        // example:
        // <svg width='500' height='500' viewBox='0 0 285 350' fill='none' xmlns='http://www.w3.org/2000/svg'><path fill='black' d='M150,0,L75,200,L225,200,Z'></path></svg>
        // data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nNTAwJyBoZWlnaHQ9JzUwMCcgdmlld0JveD0nMCAwIDI4NSAzNTAnIGZpbGw9J25vbmUnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PHBhdGggZmlsbD0nYmxhY2snIGQ9J00xNTAsMCxMNzUsMjAwLEwyMjUsMjAwLFonPjwvcGF0aD48L3N2Zz4=
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">',
                        '<g id="eye1">',
                        '<ellipse stroke-width="3" ry="29.5" rx="29.5" id="svg_1" cy="154.5" cx="181.5" stroke="#000" fill="#fff"/>',
                        '<ellipse ry="3.5" rx="2.5" id="svg_3" cy="154.5" cx="173.5" stroke-width="3" stroke="#000" fill="#000000"/>',
                        "</g>",
                        '<g id="head">',
                        '<ellipse fill="#',
                        getColor(color),
                        '" stroke-width="3" cx="204.5" cy="211.80065" id="svg_5" rx="',
                        chubbiness.toString(),
                        '" ry="51.80065" stroke="#000"/>',
                        "</g>",
                        '<g id="eye2">',
                        '<ellipse stroke-width="3" ry="29.5" rx="29.5" id="svg_2" cy="168.5" cx="209.5" stroke="#000" fill="#fff"/>',
                        '<ellipse ry="3.5" rx="3" id="svg_4" cy="169.5" cx="208" stroke-width="3" fill="#000000" stroke="#000"/>',
                        "</g>",
                        batchGenerator(batch),
                        statsBar(chubbiness),
                        "</svg>"
                    )
                )
            )
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function formatTokenURI(string memory imageURI)
        public
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "Block Monster", // You can add whatever name here
                                '", "description":"An NFT based on SVG!", "attributes":"", "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
